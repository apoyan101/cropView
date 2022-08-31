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
        navigationItem.backButtonTitle = ""
        if !UserController.isLoggedIn {
            UserController.login { success in
                print("User logged in: \(success)")
            }
        }
    }

    func showDataLoadingView() {
        if loaderView == nil {
            view.isUserInteractionEnabled = false
            loaderView = Loader.showOn(view)
        }
    }

    func hideDataLoadingView() {
        view.isUserInteractionEnabled = true
        loaderView?.remove()
        loaderView = nil
    }

    func showAlert(title: String? = nil, message: String, completion: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alertVC, animated: true)
    }
}
