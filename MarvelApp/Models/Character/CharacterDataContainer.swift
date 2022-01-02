//
//  CharacterDataContainer.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 30.12.2021.
//

import Foundation

struct CharacterDataContainer: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [CharacterModel]?

    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}
