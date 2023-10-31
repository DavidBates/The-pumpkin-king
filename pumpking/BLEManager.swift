//
//  BLEManager.swift
//  pumpking
//
//  Created by David Bates on 10/25/23.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    // Constants for the ESP32 device
    private static let DEVICE_NAME = "Pumpkin King Human Detector"
    private static let SERVICE_UUID = "BF5CBE24-E475-4EF2-B3A4-B2B1E498EB94"
    private static let CHARACTERISTIC_UUID = "B07488D0-BEDA-457F-8169-C7AA6AB8C6A8"

    @Published var isConnected: Bool = false
    @Published var isPersonDetected: Bool = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Match by name
        if let name = peripheral.name, name == BLEManager.DEVICE_NAME {
            self.peripheral = peripheral
            self.peripheral?.delegate = self
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.isConnected = true
        peripheral.discoverServices([CBUUID(string: BLEManager.SERVICE_UUID)])
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == CBUUID(string: BLEManager.SERVICE_UUID) {
                    peripheral.discoverCharacteristics([CBUUID(string: BLEManager.CHARACTERISTIC_UUID)], for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == CBUUID(string: BLEManager.CHARACTERISTIC_UUID) {
                    if characteristic.properties.contains(.read) {
                        peripheral.readValue(for: characteristic)
                    }
                    if characteristic.properties.contains(.notify) {
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let valueString = String(data: data, encoding: .utf8)
            if valueString == "PERSON_DETECTED" {
                isPersonDetected = true
            } else if valueString == "NO_PERSON" {
                isPersonDetected = false
            }
        }
    }

    // MARK: - Helper Functions
    
    private func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
}
