//
//  GetLibraryUseCase.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

struct GetLibraryUseCase: UseCase {
    
    struct Query: UseCaseQuery {}
    
    let musicRepository: MusicRepository
    
    func buildObservable(_ query: Query) -> Observable<[Searchable]> {
        Publishers.Zip4(musicRepository.getSavedAlbums(),
                          musicRepository.getSavedPlaylists(),
                          musicRepository.getSavedTracks(),
                          musicRepository.getFollowedArtists())
        .map {$0 + $1 + $2 + $3}
        .asObservable()
    }
}
