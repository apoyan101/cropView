//
//  Response.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import Foundation

struct Response<T>: Decodable where T: Decodable  {
    private(set) var data: T?
    private(set) var msg: String = String()
    private(set) var status: Int = -1

    var isSuccess: Bool {
        status == 200
    }
}
