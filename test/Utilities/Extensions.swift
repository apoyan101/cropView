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

extension UIImageView {
    var frameForImageInImageViewAspectFit: CGSize {
        if let img = image {
            let imageRatio = img.size.width / img.size.height
            let viewRatio = frame.size.width / frame.size.height
            if imageRatio < viewRatio {
                let scale = frame.size.height / img.size.height
                let width = scale * img.size.width
                return CGSize(width: width, height: frame.size.height)
            } else {
                let scale = frame.size.width / img.size.width
                let height = scale * img.size.height
                return CGSize(width: frame.size.width, height: height)
            }
        }
        return CGSize(width: 0, height: 0)
    }
}

extension UICollectionView {
    func registerNibForCell(names: [String]) {
        for name in names {
            register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        }
    }
}

extension UIResponder {
    static var id: String {
        return String(describing: self)
    }
}

extension UIImage {
    func crop(_ rect: CGRect, scale: CGFloat = 1) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
}

extension UIWindow {
    static func bottomSafeAreaHeight() -> CGFloat {
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.connectedScenes.flatMap({($0 as? UIWindowScene)?.windows ?? []}).first(where: {$0.isKeyWindow}) {
                bottomSafeAreaHeight = window.safeAreaInsets.bottom
            }
        }
        return bottomSafeAreaHeight
    }

    static func topSafeAreaHeight() -> CGFloat {
        var topSafeAreaHeight: CGFloat = 20
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.connectedScenes.flatMap({($0 as? UIWindowScene)?.windows ?? []}).first(where: {$0.isKeyWindow}) {
                topSafeAreaHeight = window.safeAreaInsets.top
            }
        }
        return topSafeAreaHeight
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

extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
