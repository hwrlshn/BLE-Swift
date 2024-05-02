//
//  AppDelegate.swift
//  BLE-Swift
//
//  Created by Bohdan Hawrylyshyn on 30.04.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let ble = BLEScanner()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let window = UIWindow(frame: UIScreen.main.bounds)
            
            let vc = DevicesViewController()
            vc.ble = ble
            
            let nav = UINavigationController(rootViewController: vc)
            window.rootViewController = nav
            
            self.window = window
            window.makeKeyAndVisible()
            return true
        }
    
}
