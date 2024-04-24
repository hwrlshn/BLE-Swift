//
//  Coordinator.swift
//  BLESwift
//
//  Created by Bohdan Hawrylyshyn on 25.04.24.
//

import UIKit
import Swinject

protocol Coordinator: AnyObject {
    
    var container: Container { get }
    
    func start()
}

protocol NavigationCoordinator: Coordinator {
    
    var navigationController: UINavigationController { get }
}
