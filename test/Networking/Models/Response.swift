//
//  Response.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import Foundation

struct Response<T>: Decodable where T: Decodable  {
    private(set) var data: T?
    private(set) var msg: String
    private(set) var status: Int

    var isSuccess: Bool {
        status == 200
    }

    init() {
        data = nil
        msg = ""
        status = -1
    }
}
