//
//  BLEScanner.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import Foundation
import CoreBluetooth

protocol ScannerUpdate {
    func updatePeripheral()
    func connectedDevice(title: String)
    func updateDistance(distance: Double)
}

final class BLEScanner: NSObject, ObservableObject {
    
    var delegate: ScannerUpdate?
    
    var isPoweredOn = false
    
    var foundPeripheral = [Peripheral]()
    var foundServices =  [Service]()
    var foundCharacteristics = [Characteristic]()
    
    var connectedPeripheral: Peripheral?
    
    private var centralManager: CBCentralManager?
    
    var foundPeripheralSet = Set<CBPeripheral>()
    var scanTimer: Timer?
    var rssiTimer: Timer?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func connectPeripheral(_ selectPeripheral: Peripheral!) {
        guard let connectPeripheral = selectPeripheral else { return }
        connectedPeripheral = selectPeripheral
        centralManager?.connect(connectPeripheral.peripheral, options: nil)
        print("Connecting to device")
    }
    
}

// MARK: - Central Manager Delegate -

extension BLEScanner: CBCentralManagerDelegate  {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown, .resetting, .unsupported, .unauthorized:
            stopScan()
        case .poweredOff:
            isPoweredOn = false
            stopScan()
        case .poweredOn:
            isPoweredOn = true
            startScan()
        @unknown default:
            print("State is unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        } else if let name = peripheral.name {
            peripheralName = name
        } else {
            peripheralName = "Unknown device (\(peripheral.identifier)"
        }
        
        if !foundPeripheralSet.contains(peripheral) {
            let device: Peripheral = .init(
                id: peripheral.identifier,
                peripheral: peripheral,
                deviceName: peripheralName,
                advertisedData: advertisementData,
                rssi: RSSI.intValue)
            foundPeripheral.append(device)
            foundPeripheralSet.insert(peripheral)
            delegate?.updatePeripheral()
        } else {
            if let index = foundPeripheral.firstIndex(where: { $0.peripheral == peripheral }) {
                foundPeripheral[index].advertisedData = advertisementData
                delegate?.updatePeripheral()
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard let connectedPeripheral = connectedPeripheral else { return }
        print("Connected peripheral info: \(connectedPeripheral)")
        self.connectedPeripheral?.peripheral = peripheral
        self.connectedPeripheral?.peripheral.delegate = self
        rssiTimer?.invalidate()
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.connectedPeripheral?.peripheral.readRSSI()
        }
        delegate?.connectedDevice(title: connectedPeripheral.deviceName)
    }
    
}

// MARK: - Peripheral Delegate -

extension BLEScanner: CBPeripheralDelegate {
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        rssiTimer?.invalidate()
        rssiTimer = nil
        calculateDistanceToDevice(rssi: 999999.0)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
        calculateDistanceToDevice(rssi: RSSI)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard let services = peripheral.services
        else { return }
        for service in services {
            foundServices.append(Service(uuid: service.uuid, service: service))
            print("didDiscoverServices for \(service)\n")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics
        else { return }
        for characteristic in characteristics {
            foundCharacteristics.append(Characteristic(uuid: characteristic.uuid, service: service, characteristic: characteristic, description: "", readValue: ""))
            peripheral.readValue(for: characteristic)
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
}

// MARK: - Stop/Start scan -

private extension BLEScanner {
    
    func stopScan() {
        print("Stop Scan")
        scanTimer?.invalidate()
        centralManager?.stopScan()
    }
    
    func startScan() {
        guard centralManager?.state == .poweredOn
        else { return }
        print("Start Scan")
        
        foundPeripheral.removeAll()
        foundPeripheralSet.removeAll()
        foundServices.removeAll()
        foundCharacteristics.removeAll()
        
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        scanTimer?.invalidate()
        scanTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
            self?.centralManager?.stopScan()
            self?.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func calculateDistanceToDevice(rssi: NSNumber) {
        switch rssi {
        case 999999.0:
            delegate?.updateDistance(distance: 999999.0)
        default:
            let txPower = -59.0
            let n = 2.0
            let ratio = rssi.doubleValue / txPower
            var distance: Double
            if ratio < 1.0 {
                distance = pow(ratio, 10)
            } else {
                distance = (0.89976) * pow(ratio, 7.7095) + 0.111
            }
            delegate?.updateDistance(distance: (distance * 100).rounded() / 100)
        }
    }
    
}
