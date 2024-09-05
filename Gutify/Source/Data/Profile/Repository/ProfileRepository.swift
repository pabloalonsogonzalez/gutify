//
//  ProfileRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

protocol ProfileRepository {
    func getProfile() -> Observable<Profile>
}

class DefaultProfileRepository: BaseRepository, ProfileRepository {
    
    enum ProfileError: Error {
    }
    
    func getProfile() -> Observable<Profile> {
        executeRequest(UsersAPI.getCurrentUsersProfileWithRequestBuilder(), mapFunction: ProfileMapper.transform)
    }
}
