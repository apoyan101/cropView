//
//  Utilitie.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit

extension Notification.Name {
    static let loginStatusDidChange = Notification.Name("loginStatusDidChange")
}

extension UIApplication {
    static var appDelegate: AppDelegate {
        return shared.delegate as! AppDelegate
    }
}

struct SettingsKey {
    static let userToken = "userToken"
    static let userDataStore = "userDataStore"
}
