//
//  CharacterDataWrapper.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 30.12.2021.
//

import Foundation

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status: String?
    let data: CharacterDataContainer?
    let etag: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    

    enum CodingKeys: String, CodingKey {
        case code
        case status
        case data
        case etag
        case copyright
        case attributionText
        case attributionHTML
        
    }
}
