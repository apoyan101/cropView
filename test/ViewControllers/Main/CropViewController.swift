//
//  MainViewController.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import UIKit

final class CropViewController: UIViewController {

    private var cropImageController: CropImageController!

    required convenience init(cropImageController: CropImageController) {
        self.init()
        self.cropImageController = cropImageController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserController.isLoggedIn {
            UserController.login { success in
                print("User logged in: \(success)")
            }
        }
        if let imageData = UIImage(named: "")?.jpegData(compressionQuality: 0.7) {
            cropImageController.uploadData(data: imageData) { imageData, isSuccess in

            }
        }
    }
}
