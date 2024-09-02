//
//  Track.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 1/9/24.
//

import Foundation

struct Track {
    var id: String
    var name: String
    var artists: [Artist]
    var album: Album
    
    var allArtists: String {
        artists.map{$0.name}.joined(separator: ", ")
    }
}
