//
//  DeviceCell.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import UIKit

class DeviceCell: UITableViewCell {
    
    @IBOutlet private weak var deviceNameLabel: UILabel!
    
    override class func description() -> String {
        "DeviceCell"
    }
    
    func setupCell(deviceName: String) {
        deviceNameLabel.text = deviceName
    }
    
}
