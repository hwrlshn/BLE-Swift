//
//  CharacteristicModel.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import CoreBluetooth

struct Characteristic: Identifiable {
    var id: UUID = UUID()
    var uuid: CBUUID
    var service: CBService
    var characteristic: CBCharacteristic
    var description: String
    var readValue: String
}
