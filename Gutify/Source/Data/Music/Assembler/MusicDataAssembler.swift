//
//  MusicDataAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol MusicDataAssembler {
    static func resolve() -> MusicRepository
}

struct DefaultMusicDataAssembler: MusicDataAssembler {

    static func resolve() -> MusicRepository {
        DefaultMusicRepository()
    }
}
