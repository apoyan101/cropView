//
//  UserController.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit

final class UserController {
    static private(set) var user: User?

    static var appDelegate: AppDelegate {
        UIApplication.appDelegate
    }

    static var isLoggedIn: Bool {
        print("Token: \(KeychainWrapper.standard.string(forKey: SettingsKey.userToken) ?? "")")
        return KeychainWrapper.standard.string(forKey: SettingsKey.userToken) != nil ? true : false
    }

    static func login(completion: @escaping (Bool) -> Void) {
        appDelegate.apiManager.userRequestController.login { user, success in
            if let user = user {
                self.user = user
                KeychainWrapper.standard.set(user.token, forKey: SettingsKey.userToken)
                NotificationCenter.default.post(name: .loginStatusDidChange, object: self, userInfo: nil)
            }
            completion(success)
        }
    }

    static func logout() {
        user = nil
        KeychainWrapper.standard.removeObject(forKey: SettingsKey.userToken)
        NotificationCenter.default.post(name: .loginStatusDidChange, object: self, userInfo: nil)
    }
}
