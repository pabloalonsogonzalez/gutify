//
//  Album.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 1/9/24.
//

import Foundation

struct Album: Searchable {
    var id: String
    var name: String
    var imageUrl: URL?
    var releaseDate: String
    var artists: [Artist]
    
    var allArtists: String {
        artists.map{$0.name}.joined(separator: ", ")
    }
}
