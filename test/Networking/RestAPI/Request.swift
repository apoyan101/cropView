//
//  Request.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import Foundation
import Alamofire

final class Request {
    private(set) var baseURLString = "https://devapi.loupefy.com"
    private(set) var pathURLString: String
    private(set) var parameters: [String: Any]
    private(set) var httpHeadres: HTTPHeaders
    private(set) var httpMethod: HTTPMethod

    var url: URL {
        URL(string: baseURLString + pathURLString)!
    }

    var request: URLRequest {
        var urlRequest = try! URLRequest(url: url, method: httpMethod, headers: httpHeadres)
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
        return urlRequest
    }

    init(path: String, method: HTTPMethod = .post, params: [String: Any]? = nil) {
        pathURLString = path
        httpMethod = method
        var headers = HTTPHeaders()
        if let accessToken = KeychainWrapper.standard.string(forKey: SettingsKey.userToken) {
            headers["token"] = accessToken
        }
        headers["deviceid"] = "test-device"
        httpHeadres = headers
        parameters = params ?? [:]
    }

    // MARK: - Response -

    func responseObject<T: Decodable>(type: T.Type = T.self, completion: @escaping (Response<T>) -> Void) {
        AF.request(request).responseDecodable { (response: DataResponse<Response<T>, AFError>) in
            switch response.result {
            case .success(let data):
                if data.data == nil, data.status != 200, let url = response.request?.url {
                    print("Error: \(data.msg) from \(url)")
                }
                completion(data)
            case .failure(let error):
                print("Alamofire error", error.localizedDescription, "from - \(String(describing: response.request?.url))")
                print(response)
                completion(Response())
            }
        }
    }
}
