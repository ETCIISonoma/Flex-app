import Combine
import Foundation
import AccessorySetupKit
import CoreBluetooth
import SwiftUI

enum GlobalState: UInt8, CaseIterable {
    case notAttached = 0
    case touchedASurface = 1
    case activatingPump = 2
    case transitioningSuccessfully = 3
    case home = 4
    case tryAgain = 5
    case failure = 6
}

enum ViewState {
    case instruction
    case hold
    case confirmation
    case activeWorkout
    case home
    case tryAgain
    case replace
    case setBreak
    case remove
    case pickUp
    case notStarted
}

class AccessorySessionManager: NSObject, ObservableObject {
    
    static let shared = AccessorySessionManager()
    @Published var wf: workoutFlag
    
    @Published var accessoryModel: AccessoryModel?
    {
        didSet {
            print("got here")
        }
    }
    @Published var globalState: GlobalState
    {
        willSet {
            let oldValue = globalState
            let newValue = newValue

            switch newValue {
            case .notAttached:
                if(wf.workoutFinished) {
                    wf.initialPickUp = false
                    self.viewState = .home
                } else {
                    wf.initialPickUp = true
                    self.viewState = .instruction
                }
                wf.navigateToRePlace = false
                wf.navigateToSetBreak = false
                wf.setBreakFinished = false
            case .touchedASurface, .activatingPump:
                print(wf.initialPickUp)
                print(wf.workoutFinished)
                /*if(wf.workoutFinished) { // 7) Review whether this condition should be here - shouldnt it also stay on home if workout finished but its on a surface?
                    wf.initialPickUp = false
                    self.viewState = .home
                    //self.viewState = .notStarted
                }*/
                if(!wf.initialPickUp) {
                    self.viewState = .pickUp
                    wf.initialPickUp = true // 5) Need to be able to set this to false at end of the workout - Done
                }
                else if(!wf.workoutFinished) {
                    self.viewState = .hold
                }
            case .transitioningSuccessfully:
                if oldValue == .activatingPump {
                    self.viewState = .confirmation
                    print("got to confirm")
                } else if self.previousViewStates.contains(.confirmation) { // 6) maybe change this to if view state is currently confirmation???
                //else if self.viewState == .confirmation {
                    print("got to active")
                    self.viewState = .activeWorkout
                }
            case .home:
                print("got home")
                print(self.viewState)
                print(wf.navigateToRePlace)
                print(wf.navigateToSetBreak)
                print(wf.navigateToHome)
                if wf.navigateToRePlace || wf.setBreakFinished {
                    print("case1")
                    self.viewState = .replace
                } else if wf.navigateToSetBreak {
                    self.viewState = .setBreak
                } else if wf.navigateToHome { // 2) Need to add condition also for workout is over and also ensure it stays on home till new workout started.
                    self.viewState = .remove
                }
                else {
                    print("got here")
                    print(wf.navigateToRePlace)
                    print(wf.navigateToSetBreak)
                    print(wf.navigateToHome)
                }
            case .tryAgain:
                self.viewState = .tryAgain
            case .failure:
                if oldValue == .activatingPump {
                    self.viewState = .confirmation
                } else if self.previousViewStates.contains(.confirmation) {
                    self.viewState = .hold
                }
            }
        }
    }
    
    @Published var viewState: ViewState {
        didSet {
          self.previousViewStates.append(viewState)
        }
    }
    var previousViewStates: [ViewState]
    
    @Published var motorTorqueSetpoint: Float? = nil
    @Published var batteryVoltage: Float? = nil
    @Published var motorPower: Float? = nil
    @Published var peripheralConnected = false
    @Published var pickerDismissed = true
    @Published var repCount: UInt8? = nil

    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var manager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var w_motorTorqueSetpointCharacteristic: CBCharacteristic?
    private var r_w_globalStateCharacteristic: CBCharacteristic?
    private var r_batteryVoltageCharacteristic: CBCharacteristic?
    private var r_motorPowerCharacteristic: CBCharacteristic?
    private var r_repCountCharacteristic: CBCharacteristic?

    private static let w_motorTorqueSetpointCharacteristicUUID = "0xFF3F"
    private static let r_w_globalStateCharacteristicUUID = "0xFF40"
    private static let r_batteryVoltageCharacteristicUUID = "0xFF41"
    private static let r_motorPowerCharacteristicUUID = "0xFF42"
    private static let r_repCountCharacteristicUUID = "0xFF43"
    
    //private let sequence: [ViewState]
    private var counterSeq = 0

    private static let flexF1: ASPickerDisplayItem = {
        let descriptor = ASDiscoveryDescriptor()
        descriptor.bluetoothServiceUUID = AccessoryModel.flexF1.serviceUUID

        return ASPickerDisplayItem(
            name: AccessoryModel.flexF1.displayName,
            productImage: AccessoryModel.flexF1.accessoryImage,
            descriptor: descriptor
        )
    }()
    
    //private init() {}

    private override init() {
        globalState = .notAttached
        viewState = .notStarted
        previousViewStates = []
        
        self.wf = .init(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false)
        
        //self.sequence = [.pickUp, .instruction, .hold, .confirmation, .notStarted]
        super.init()

        self.session.activate(on: DispatchQueue.main, eventHandler: handleSessionEvent(event:))
        
        /*let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.viewState = self.sequence[self.counterSeq]
            self.counterSeq += 1
        }
        
        self.wf.$workoutFinished.sink { newValue in
            print(newValue)
        }*/
    }

    // MARK: - AccessorySessionManager actions

    func presentPicker() {
        session.showPicker(for: [Self.flexF1]) { error in
            if let error {
                print("Failed to show picker due to: \(error.localizedDescription)")
            }
        }
    }

    func removeAccessory() {
        guard let currentAccessory else { return }

        if peripheralConnected {
            disconnect()
        }

        session.removeAccessory(currentAccessory) { _ in
            self.accessoryModel = nil
            self.currentAccessory = nil
            self.manager = nil
        }
    }

    func connect() {
        guard
            let manager, manager.state == .poweredOn,
            let peripheral
        else {
            return
        }

        manager.connect(peripheral)
    }

    func disconnect() {
        guard let peripheral, let manager else { return }
        manager.cancelPeripheralConnection(peripheral)
    }

    // MARK: - ASAccessorySession functions

    private func saveAccessory(accessory: ASAccessory) {
        UserDefaults.standard.set(true, forKey: "accessoryPaired")

        currentAccessory = accessory

        if manager == nil {
            manager = CBCentralManager(delegate: self, queue: nil)
        }

        if accessory.displayName == AccessoryModel.flexF1.displayName {
            accessoryModel = .flexF1
        }
    }

    private func handleSessionEvent(event: ASAccessoryEvent) {
        switch event.eventType {
        case .accessoryAdded, .accessoryChanged:
            guard let accessory = event.accessory else { return }
            saveAccessory(accessory: accessory)
        case .activated:
            guard let accessory = session.accessories.first else { return }
            saveAccessory(accessory: accessory)
        case .accessoryRemoved:
            self.accessoryModel = nil
            self.currentAccessory = nil
            self.manager = nil
        case .pickerDidPresent:
            pickerDismissed = false
        case .pickerDidDismiss:
            pickerDismissed = true
        default:
            print("Received event type \(event.eventType)")
        }
    }

    func readVoltage() -> Float? {
        return batteryVoltage
    }

    func readState() -> UInt8? {
        return globalState.rawValue
    }

    func writeState(state: UInt8) {
        Task {
            if let globalStateCharacteristic = r_w_globalStateCharacteristic {
                let data = Data([state])
                peripheral?.writeValue(data, for: globalStateCharacteristic, type: .withResponse)
            }
        }
    }

    func writeTorque(torque: UInt8) {
        Task {
            if let motorTorqueCharacteristic = w_motorTorqueSetpointCharacteristic {
                let data = Data([torque])
                peripheral?.writeValue(data, for: motorTorqueCharacteristic, type: .withResponse)
            }
        }
    }
    
    /*func writeRep(rep: UInt8) {
        Task {
            if let repCountCharacteristic = r_repCountCharacteristic {
                let data = Data([rep])
                peripheral?.writeValue(data, )
            }
        }
    }*/
}

// MARK: - CBCentralManagerDelegate

extension AccessorySessionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central manager state: \(central.state)")
        switch central.state {
        case .poweredOn:
            if let peripheralUUID = currentAccessory?.bluetoothIdentifier {
                peripheral = central.retrievePeripherals(withIdentifiers: [peripheralUUID]).first
                peripheral?.delegate = self
            }
        default:
            peripheral = nil
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        guard let accessoryModel else { return }
        peripheral.delegate = self
        peripheral.discoverServices([accessoryModel.serviceUUID])

        peripheralConnected = true
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("Disconnected from peripheral: \(peripheral)")
        peripheralConnected = false
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("Failed to connect to peripheral: \(peripheral), error: \(error.debugDescription)")
    }
}

// MARK: - CBPeripheralDelegate

extension AccessorySessionManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard
            error == nil,
            let services = peripheral.services
        else {
            return
        }

        for service in services {
            peripheral.discoverCharacteristics([CBUUID(string: Self.w_motorTorqueSetpointCharacteristicUUID), CBUUID(string: Self.r_w_globalStateCharacteristicUUID), CBUUID(string: Self.r_batteryVoltageCharacteristicUUID), CBUUID(string: Self.r_motorPowerCharacteristicUUID), CBUUID(string: Self.r_repCountCharacteristicUUID)], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard
            error == nil,
            let characteristics = service.characteristics
        else {
            return
        }

        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: Self.r_batteryVoltageCharacteristicUUID) {
                r_batteryVoltageCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid == CBUUID(string: Self.r_motorPowerCharacteristicUUID) {
                r_motorPowerCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid == CBUUID(string: Self.r_repCountCharacteristicUUID) {
                r_repCountCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid == CBUUID(string: Self.r_w_globalStateCharacteristicUUID) {
                r_w_globalStateCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid == CBUUID(string: Self.w_motorTorqueSetpointCharacteristicUUID) {
                w_motorTorqueSetpointCharacteristic = characteristic
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        guard error == nil, let data = characteristic.value else { return }

        if characteristic.uuid == CBUUID(string: Self.r_motorPowerCharacteristicUUID) {
            let motorPower = data.withUnsafeBytes { $0.load(as: Float.self) }
            print("New power received: \(motorPower)")
            DispatchQueue.main.async {
                withAnimation {
                    self.motorPower = motorPower
                }
            }
        }
        
        if characteristic.uuid == CBUUID(string: Self.r_repCountCharacteristicUUID) {
            let repCount = data.withUnsafeBytes { $0.load(as: UInt8.self) }
            print("New rep received: \(repCount)")
            DispatchQueue.main.async {
                withAnimation {
                    self.repCount = repCount
                }
            }
        }

        if characteristic.uuid == CBUUID(string: Self.r_batteryVoltageCharacteristicUUID) {
            let batteryVoltage = data.withUnsafeBytes { $0.load(as: Float.self) }
            print("New battery voltage received: \(batteryVoltage)")
            DispatchQueue.main.async {
                withAnimation {
                    self.batteryVoltage = batteryVoltage
                }
            }
        }

        if characteristic.uuid == CBUUID(string: Self.r_w_globalStateCharacteristicUUID) {
            let globalState = data.withUnsafeBytes { $0.load(as: UInt8.self) }
            print("New global state received: \(globalState)")
            DispatchQueue.main.async {
                withAnimation {
                    self.globalState = GlobalState(rawValue: globalState) ?? .notAttached
                }
            }
        }
    }
}
