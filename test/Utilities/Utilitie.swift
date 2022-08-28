//
//  Utilitie.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit

extension UIView {
    func addSubviewWithLayoutToBounds(subview: UIView, insets: UIEdgeInsets = .zero, isForSafeArea: Bool = false) {
        addSubview(subview)
        addConstraintToBounds(subView: subview, insets: insets, isForSafeArea: isForSafeArea)
    }

    private func addConstraintToBounds(subView: UIView, insets: UIEdgeInsets, isForSafeArea: Bool) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        if isForSafeArea {
            let guide = safeAreaLayoutGuide
            subView.topAnchor.constraint(equalTo: guide.topAnchor, constant: insets.top).isActive = true
            subView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -insets.right).isActive = true
        } else {
            subView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
            subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
        }
    }
}

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
