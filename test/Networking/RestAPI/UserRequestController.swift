//
//  UserRequestController.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import Foundation

final class UserRequestController: RequestController {
    func login(completion: @escaping (User?, Bool) -> Void) {
        request(path: "/auth/guest").responseObject { response in
            completion(response.data, response.isSuccess)
        }
    }
}
