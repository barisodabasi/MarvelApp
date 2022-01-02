//
//  CharacterModel.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 30.12.2021.
//

import Foundation

struct CharacterModel: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var resourceURI: String?
    var urls: [Url]?
    var thumbnail: Image?
    var comics: ComicList?
}
