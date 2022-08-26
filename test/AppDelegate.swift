//
//  AppDelegate.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) var apiManager: ApiManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appConfigHasLoaded()
        window!.rootViewController = MainViewController()
        window!.makeKeyAndVisible()
        return true
    }

    private func appConfigHasLoaded() {
        apiManager = ApiManager()
    }
}

