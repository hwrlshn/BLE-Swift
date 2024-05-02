//
//  DetailsViewController.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 01.05.24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private lazy var distanceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

// MARK: - Distance delegate -

extension DetailsViewController: DistanceDelegate {
    
    func passDistance(_ number: Double) {
        switch number {
        case 999999.0:
            distanceLabel.text = "Device disconnected"
        default:
            distanceLabel.text = "Distance to device: \(number)m"
        }
    }
    
}

// MARK: - Setup UI -

private extension DetailsViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        distanceLabel.text = "Distance to device: ???"
        distanceLabel.textColor = .white
        view.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(
            item: distanceLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0)
        let verticalConstraint = NSLayoutConstraint(
            item: distanceLabel,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1,
            constant: 0)
        view.addConstraints([
            horizontalConstraint,
            verticalConstraint
        ])
    }
    
}
