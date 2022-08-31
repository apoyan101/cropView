//
//  UploadDataRequestController.swift
//  test
//
//  Created by Ara Apoyan on 27.08.22.
//

import Foundation

final class UploadDataRequestController: RequestController {
    func uploadData(data: Data, dataName: String, completion: @escaping (ImageData?, String, Bool) -> Void) {
        request(path: "/localization").uploadData(data: data, dataName: dataName) { response in
            completion(response?.data, response?.msg ?? "", response?.isSuccess ?? false)
        }
    }
}
