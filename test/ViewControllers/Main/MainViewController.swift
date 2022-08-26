//
//  MainViewController.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !UserController.isLoggedIn {
            UserController.login { success in

            }
        }
    }
}
