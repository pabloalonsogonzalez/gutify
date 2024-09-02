//
//  Album.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 1/9/24.
//

import Foundation

struct Playlist: Searchable {
    var id: String
    var name: String
    var imageUrl: URL?
    var tracksNumber: Int
}
