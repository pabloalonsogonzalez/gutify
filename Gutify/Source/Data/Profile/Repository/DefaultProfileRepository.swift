//
//  ProfileRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

class DefaultProfileRepository: BaseRepository, ProfileRepository {
    
    func getProfile() -> Observable<Profile> {
        executeRequest(UsersAPI.getCurrentUsersProfileWithRequestBuilder(), mapFunction: ProfileMapper.transform)
    }
}
