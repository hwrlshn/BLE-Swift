//
//  AppCoordinator.swift
//  BLESwift
//
//  Created by Bohdan Hawrylyshyn on 25.04.24.
//

import UIKit
import Swinject

enum AppChildCoordinator { }

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    let container: Container
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        
        navigationController = UINavigationController() &> {
            $0.view.backgroundColor = .systemBackground
        }
        
        self.window.rootViewController = navigationController
    }
    
    func start() {
        
    }
    
}
