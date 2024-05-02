//
//  DevicesViewController.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import UIKit

protocol DistanceDelegate: AnyObject {
    func passDistance(_ distance: Double)
}

class DevicesViewController: UITableViewController {
    
    weak var ble: BLEScanner?
    weak var delegate: DistanceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Devices"
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

// MARK: - Distance Delegate -

extension DevicesViewController: DistanceDelegate {
    
    func passDistance(_ distance: Double) {
        delegate?.passDistance(distance)
    }
    
}

// MARK: - BLE Delegate -

extension DevicesViewController: ScannerUpdate {
    
    func updateDistance(distance: Double) {
        passDistance(distance)
    }
    
    func updatePeripheral() {
        tableView.reloadData()
    }
    
    func connectedDevice(title: String) {
        let vc = DetailsViewController()
        vc.title = title
        delegate = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
