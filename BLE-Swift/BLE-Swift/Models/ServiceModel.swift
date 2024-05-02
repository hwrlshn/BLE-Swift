//
//  ServiceModel.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import CoreBluetooth

struct Service: Identifiable {
    var id: UUID = UUID()
    var uuid: CBUUID
    var service: CBService
}
