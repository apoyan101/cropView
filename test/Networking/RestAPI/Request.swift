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
    
    func responseObject<T: Decodable>(type: T.Type = T.self, completion: @escaping (Response<T>?) -> Void) {
        AF.request(request).responseDecodable { (response: DataResponse<Response<T>, _>) in
            completion(response.value)
        }
    }

    // MARK: - Upload data -

    func uploadData<T: Decodable>(type: T.Type = T.self, data: Data, dataName: String, completion: @escaping (Response<T>?) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: dataName, mimeType: data.mimeType())
        }, with: request).responseDecodable { (response: DataResponse<Response<T>, _>) in
            completion(response.value)
        }
    }
}
