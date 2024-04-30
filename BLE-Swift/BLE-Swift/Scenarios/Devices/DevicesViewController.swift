//
//  DevicesViewController.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import UIKit

class DevicesViewController: UITableViewController {
    
    weak var ble: BLEScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ble?.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            .init(nibName: DeviceCell.description(), bundle: nil),
            forCellReuseIdentifier: DeviceCell.description())
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = ble?.foundPeripheral[indexPath.row]
        ble?.connectPeripheral(device)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Devices"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ble?.foundPeripheral.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.description(), for: indexPath) as? DeviceCell {
            let device = ble?.foundPeripheral[indexPath.row]
            cell.setupCell(deviceName: device?.deviceName ?? "")
            return cell
        }
        return .init()
    }
    
}

// MARK: - BLE Delegate -

extension DevicesViewController: ScannerUpdate {
    
    func updatePeripheral() {
        tableView.reloadData()
    }
    
    func connectedDevice() {
        
    }
    
}
