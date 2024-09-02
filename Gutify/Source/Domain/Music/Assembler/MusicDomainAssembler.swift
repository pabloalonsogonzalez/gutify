//
//  MusicDomainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol MusicDomainAssembler {
    static func resolve() -> GetUserTopTracksUseCase
    static func resolve() -> GetUserTopArtistsUseCase
}

struct DefaultMusicDomainAssembler: MusicDomainAssembler {

    static func resolve() -> GetUserTopTracksUseCase {
        GetUserTopTracksUseCase(musicRepository: DefaultMusicDataAssembler.resolve())
    }
    
    static func resolve() -> GetUserTopArtistsUseCase {
        GetUserTopArtistsUseCase(musicRepository: DefaultMusicDataAssembler.resolve())
    }
}
