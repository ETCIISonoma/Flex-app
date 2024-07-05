//
//  AccessoryConnection.swift
//  Flex
//
//  Created by Collin Cameron on 7/4/24.
//

import Foundation
import AccessorySetupKit
import CoreBluetooth
import SwiftUI

@Observable
class AccessorySessionManager: NSObject {
    var accesoryModel: AccessoryModel?
    var ultrasonicDistance: String? = nil
    var peripheralConnected = false
    var pickerDismissed = true

    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var manager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var ultrasonicDistanceCharacteristic: CBCharacteristic?
    private var relayCharacteristic: CBCharacteristic?

    private static let ultrasonicCharacteristicUuid = "0xFF3F"
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
            peripheral.discoverCharacteristics([CBUUID(string: Self.ultrasonicCharacteristicUuid), CBUUID(string: Self.relayCharacteristicUuid)], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard
            error == nil,
            let characteristics = service.characteristics
        else {
            return
        }

        for characteristic in characteristics where characteristic.uuid == CBUUID(string: Self.ultrasonicCharacteristicUuid) {
            ultrasonicDistanceCharacteristic = characteristic
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
            characteristic.uuid == CBUUID(string: Self.ultrasonicCharacteristicUuid),
            let data = characteristic.value,
            let ultrasonicDistance = String(data: data, encoding: .utf8)
        else {
            return
        }

        print("New distance value received: \(ultrasonicDistance)")

        DispatchQueue.main.async {
            withAnimation {
                self.ultrasonicDistance = ultrasonicDistance
            }
        }
    }
}
