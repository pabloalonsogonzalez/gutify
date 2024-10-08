//
//  Artist.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 1/9/24.
//

import Foundation

struct Artist: Searchable {
    var id: String
    var name: String
    var imageUrl: URL?
    var genres: [String]?
    var followers: Int?
}
