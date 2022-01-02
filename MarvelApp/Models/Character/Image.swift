//
//  Image.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 30.12.2021.
//

import Foundation

struct Image: Codable {

  var path: String?
  var ext: String?

  var url: String {
    guard let p = path, let e = ext else { return "" }
    return p + "." + e
  }

  enum CodingKeys: String, CodingKey {
    case path
    case ext = "extension"
  }
}
