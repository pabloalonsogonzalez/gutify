//
//  ProfileDataAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol ProfileDataAssembler {
    static func resolve() -> ProfileRepository
}

struct DefaultProfileDataAssembler: ProfileDataAssembler {

    static func resolve() -> ProfileRepository {
        DefaultProfileRepository()
    }
}
