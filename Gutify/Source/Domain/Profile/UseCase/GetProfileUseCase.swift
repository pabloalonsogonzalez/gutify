//
//  GetProfileUseCase.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

struct GetProfileUseCase: UseCase {
    
    struct Query: UseCaseQuery {}
    
    let profileRepository: ProfileRepository
    
    func buildObservable(_ query: Query) -> Observable<Profile> {
        profileRepository.getProfile()
    }
}
