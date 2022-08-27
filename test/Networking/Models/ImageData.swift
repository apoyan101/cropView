//
//  File.swift
//  test
//
//  Created by Ara Apoyan on 26.08.22.
//

import Foundation

struct ImageData: Decodable {
    private(set) var imageID: String
    private(set) var objects: [CropItem]?
}

struct CropItem: Decodable {
    private(set) var category: String
    private(set) var subCategory: String
    private(set) var vertices: Vertices
}

struct Vertices: Decodable {
    private(set) var bottomLeft: Coordinate
    private(set) var bottomRight: Coordinate
    private(set) var topLeft: Coordinate
    private(set) var topRight: Coordinate
}

struct Coordinate: Decodable {
    private(set) var x: Double
    private(set) var y: Double
}
