//
//  LoginDataAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol LoginDataAssembler {
    static func resolve() -> LoginRepository
}

struct DefaultLoginDataAssembler: LoginDataAssembler {

    static func resolve() -> LoginRepository {
        DefaultLoginRepository()
    }
}
