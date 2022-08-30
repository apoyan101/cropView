//
//  BaseViewController.swift
//  test
//
//  Created by Ara Apoyan on 30.08.22.
//

import UIKit

class BaseViewController: UIViewController {

    final var loaderView: Loader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        if !UserController.isLoggedIn {
            UserController.login { success in
                print("User logged in: \(success)")
            }
        }
    }
    func showDataLoadingView() {}
    func hideDataLoadingView() {}
}
