//
//  GetNewReleasesUseCase.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

struct GetNewReleasesUseCase: UseCase {
    
    struct Query: UseCaseQuery {}
    
    let musicRepository: MusicRepository
    
    func buildObservable(_ query: Query) -> Observable<[Album]> {
        musicRepository.getNewReleases()
    }
}
