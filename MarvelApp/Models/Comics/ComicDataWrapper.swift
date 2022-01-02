//
//  ComicDataWrapper.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 1.01.2022.
//

import Foundation

struct ComicDataWrapper: Codable {
    var data: APIComicData
}

struct APIComicData: Codable {
    var count: Int
    var results: [Comic]
}

struct Comic: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var thumbnail: Image?
    var urls: [[String: String]]?
}
