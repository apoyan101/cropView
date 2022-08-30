//
//  Loader.swift
//  test
//
//  Created by Ara Apoyan on 30.08.22.
//

import UIKit

final class Loader: UIView {
    static func showOn(_ superView: UIView, topInset: CGFloat = 0, indicatorTopConstant: CGFloat = 80) -> Loader {
        let loader = Loader()
        loader.backgroundColor = .systemGray.withAlphaComponent(0.8)
        superView.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.topAnchor.constraint(equalTo: superView.topAnchor, constant: topInset).isActive = true
        loader.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        loader.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        loader.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        loader.addActivityIndicator(topConstant: indicatorTopConstant)
        return loader
    }

    public func remove() {
        removeFromSuperview()
    }

    private func addActivityIndicator(topConstant: CGFloat) {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .purple
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}
