//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol LoginDomainAssembler {
    static func resolve() -> CheckLogedUserUseCase
    static func resolve() -> GetUserAuthorizationUseCase
    static func resolve() -> GetTokenUseCase
}

struct DefaultLoginDomainAssembler: LoginDomainAssembler {

    static func resolve() -> CheckLogedUserUseCase {
        CheckLogedUserUseCase(loginRepository: DefaultLoginDataAssembler.resolve())
    }
    
    static func resolve() -> GetUserAuthorizationUseCase {
        GetUserAuthorizationUseCase(loginRepository: DefaultLoginDataAssembler.resolve())
    }
    
    static func resolve() -> GetTokenUseCase {
        GetTokenUseCase(loginRepository: DefaultLoginDataAssembler.resolve())
    }
}
