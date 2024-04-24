//
//  AppDelegate.swift
//  BLESwift
//
//  Created by Bohdan Hawrylyshyn on 25.04.24.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let container = Container()
    private var appCoordinator: AppCoordinator!
    
    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupDependencies()
        return true
    }
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!, container: container)
        appCoordinator.start()
        window?.makeKeyAndVisible()
        return true
    }
    
}
