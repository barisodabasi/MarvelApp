//
//  ComicList.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 30.12.2021.
//

import Foundation

struct ComicList: Codable {

  var available: Int?
  var returned: Int?
  var collectionURI: String?
  var items: [ComicSummary]?
}
