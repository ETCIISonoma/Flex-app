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
    var rawMeasurements: String? = nil
    var peripheralConnected = false
    var pickerDismissed = true
    var onWall = false //whether it is in contact with wall to move between place F1 to hold F1 views
    var faultRecieved = false // indicates if true that hold has been attempted but not successful so move to try again screen.
    var isAttached = false // indicates if true that hold has been attempted and successful so move to success screen.
    
    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var manager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var measurementsCharacteristic: CBCharacteristic?
    private var relayCharacteristic: CBCharacteristic?

    private static let measurementsCharacteristicUuid = "0xFF3F"
    private static let relayCharacteristicUuid = "0xFF40"

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
    
    private func getMeasurementsComponent(index: Int) -> String? {
        let components = rawMeasurements?.split(separator: ",")
        let component = components?[index]
        
        guard component != nil, let component = component else {
            return nil
        }
        
        return String(component)
    }
    
    var distance: Measurement<UnitLength>? {
        let string = getMeasurementsComponent(index: 0)
        
        guard string != nil, let string = string else {
            return nil
        }
        
        if let number = Double(string) {
            return Measurement(value: number, unit: .centimeters)
        } else {
            return nil
        }
    }
    
    var orientation: AccessoryPosition? {
        let string = getMeasurementsComponent(index: 1)
        
        guard string != nil, let string = string else {
            return nil
        }
        
        if let orientation = AccessoryPosition(rawValue: string) {
            return orientation
        } else {
            return nil
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
            peripheral.discoverCharacteristics([CBUUID(string: Self.measurementsCharacteristicUuid), CBUUID(string: Self.relayCharacteristicUuid)], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard
            error == nil,
            let characteristics = service.characteristics
        else {
            return
        }

        for characteristic in characteristics where characteristic.uuid == CBUUID(string: Self.measurementsCharacteristicUuid) {
            measurementsCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
        
        for characteristic in characteristics where characteristic.uuid == CBUUID(string: Self.relayCharacteristicUuid) {
            relayCharacteristic = characteristic
        }
    }
    
    func setRelayState(isOn: Bool) {
        Task {
            if relayCharacteristic != nil {
                peripheral?.writeValue(Data([isOn ? 0x01 : 0x00]), for: relayCharacteristic!, type: .withResponse)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        guard
            error == nil,
            characteristic.uuid == CBUUID(string: Self.measurementsCharacteristicUuid),
            let data = characteristic.value,
            let rawMeasurements = String(data: data, encoding: .utf8)
        else {
            return
        }

        print("New measurements received: \(rawMeasurements)")

        DispatchQueue.main.async {
            withAnimation {
                self.rawMeasurements = rawMeasurements
            }
        }
    }
}
