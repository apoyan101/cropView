//
//  RequestManager.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import Foundation
import Alamofire

final class ApiManager {
    private(set) var userRequestController: UserRequestController!

    init() {
        userRequestController = UserRequestController()
    }
}

class RequestController {
    func request(path: String, httpMethod: HTTPMethod = .post, params: [String: Any]? = nil) -> Request {
        return Request(path: path, method: httpMethod, params: params)
    }
}
