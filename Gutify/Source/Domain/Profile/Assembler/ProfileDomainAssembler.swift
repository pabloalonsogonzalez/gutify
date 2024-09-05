//
//  ProfileDomainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol ProfileDomainAssembler {
    static func resolve() -> GetProfileUseCase
}

struct DefaultProfileDomainAssembler: ProfileDomainAssembler {

    static func resolve() -> GetProfileUseCase {
        GetProfileUseCase(profileRepository: DefaultProfileDataAssembler.resolve())
    }
}
