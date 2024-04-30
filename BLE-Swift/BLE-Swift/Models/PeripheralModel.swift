//
//  PeripheralModel.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import CoreBluetooth

struct Peripheral: Identifiable {
    var id: UUID
    var peripheral: CBPeripheral
    var deviceName: String
    var advertisedData: [String : Any]
    var rssi: Int
}
