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
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        window = UIWindow(frame: UIScreen.main.bounds)
        apiManager = ApiManager()
        let cropImageController = CropImageController()
        let cropViewController = CropViewController(cropImageController: cropImageController)
        let navigationController = UINavigationController(rootViewController: cropViewController)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
}

