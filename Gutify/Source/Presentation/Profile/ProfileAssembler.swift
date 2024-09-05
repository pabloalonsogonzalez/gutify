//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol ProfileAssembler {
    static func resolve() -> ProfileView
    static func resolve() -> ProfileViewModel
}

struct DefaultProfileAssembler: ProfileAssembler {

    static func resolve() -> ProfileView {
        ProfileView(viewModel: resolve())
    }
    static func resolve() -> ProfileViewModel {
        ProfileViewModel(getProfileUseCase: DefaultProfileDomainAssembler.resolve(),
                         removeTokenUseCase: DefaultLoginDomainAssembler.resolve())
    }
}
