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

extension Data {
    func mimeType() -> String {
        var bytes: UInt8 = 0
        copyBytes(to: &bytes, count: 1)
        switch bytes {
        case 0xFF: return "image/jpeg"
        case 0x89: return "image/png"
        case 0x47: return "image/gif"
        case 0x4D, 0x49: return "image/tiff"
        case 0x25: return "application/pdf"
        case 0xD0: return "application/vnd"
        case 0x46: return "text/plain"
        default: return "application/octet-stream"
        }
    }
}

struct SettingsKey {
    static let userToken = "userToken"
    static let userDataStore = "userDataStore"
}
