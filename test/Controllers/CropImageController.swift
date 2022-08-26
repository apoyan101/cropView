//
//  CropController.swift
//  test
//
//  Created by Ara Apoyan on 27.08.22.
//

import UIKit
import CropPickerView

final class CropImageController {
    func uploadData(data: Data, completion: @escaping (ImageData?, Bool) -> Void) {
        let dataName = UUID().uuidString
        UIApplication.appDelegate.apiManager.uploadDataRequestController.uploadData(data: data, dataName: dataName) { imageData, isSuccess in
            completion(imageData, isSuccess)
        }
    }
}
