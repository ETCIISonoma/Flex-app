//
//  AccessoryConnection.swift
//  Flex
//

import Foundation
import AccessorySetupKit
import CoreBluetooth
import SwiftUI

@Observable
class AccessorySessionManager: NSObject {
    var accesoryModel: AccessoryModel?
    var globalState: UInt? = nil
    var motorTorqueSetpoint: Float? = nil
    var batteryVoltage: Float? = nil
    var motorPower: Float? = nil
    var peripheralConnected = false
    var pickerDismissed = true

    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var manager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var w_motorTorqueSetpointCharacteristic: CBCharacteristic?
    private var r_w_globalStateCharacteristic: CBCharacteristic?
    private var r_batteryVoltageCharacteristic: CBCharacteristic?
    private var r_motorPowerCharacteristic: CBCharacteristic?
    
    private static let w_motorTorqueSetpointCharacteristicUUID = "0xFF3F"
    private static let r_w_globalStateCharacteristicUUID = "0xFF40"
    private static let r_batteryVoltageCharacteristicUUID = "0xFF41"
    private static let r_motorPowerCharacteristicUUID = "0xFF42"

    private static let flexF1: ASPickerDisplayItem = {
        let descriptor = ASDiscoveryDescriptor()
        descriptor.bluetoothServiceUUID = AccessoryModel.flexF1.serviceUUID

        return ASPickerDisplayItem(
            name: AccessoryModel.flexF1.displayName,
            productImage: AccessoryModel.flexF1.accessoryImage,
            descriptor: descriptor
        )
    }()

    override init() {
        super.init()
        self.session.activate(on: DispatchQueue.main, eventHandler: handleSessionEvent(event:))
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
            self.accesoryModel = nil
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
            accesoryModel = .flexF1
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
            self.accesoryModel = nil
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
    
    func readState() -> UInt? {
        return globalState
    }
    
    func writeState(state: UInt) {
        Task {
            if let globalStateCharacteristic = r_w_globalStateCharacteristic {
                let data = Data([UInt8(state)])
                peripheral?.writeValue(data, for: globalStateCharacteristic, type: .withResponse)
            }
        }
    }
    
    func writeTorque(torque: UInt) {
        Task {
            if let motorTorqueCharacteristic = w_motorTorqueSetpointCharacteristic {
                let data = Data([UInt8(torque)])
                peripheral?.writeValue(data, for: motorTorqueCharacteristic, type: .withResponse)
            }
        }
    }
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
        guard let accesoryModel else { return }
        peripheral.delegate = self
        peripheral.discoverServices([accesoryModel.serviceUUID])

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
            peripheral.discoverCharacteristics([CBUUID(string: Self.w_motorTorqueSetpointCharacteristicUUID), CBUUID(string: Self.r_w_globalStateCharacteristicUUID), CBUUID(string: Self.r_batteryVoltageCharacteristicUUID), CBUUID(string: Self.r_motorPowerCharacteristicUUID)], for: service)
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
            let globalState = data.withUnsafeBytes { $0.load(as: UInt.self) }
            print("New global state received: \(globalState)")
            DispatchQueue.main.async {
                withAnimation {
                    self.globalState = globalState
                }
            }
        }
    }
}
