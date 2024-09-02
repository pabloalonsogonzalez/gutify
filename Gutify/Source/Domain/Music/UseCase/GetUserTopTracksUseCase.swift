//
//  GetUserTopTracksUseCase.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

struct GetUserTopTracksUseCase: UseCase {
    
    struct Query: UseCaseQuery {}
    
    let musicRepository: MusicRepository
    
    func buildObservable(_ query: Query) -> Observable<[Track]> {
        musicRepository.getUserTopTracks()
    }
}
