//
//  GetTokenUseCase.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

struct GetTokenUseCase: UseCase {
    
    struct Query: UseCaseQuery {
        var codeVerifier: String
        var authorizationCode: String
    }
    
    let loginRepository: LoginRepository
    
    func buildObservable(_ query: Query) -> Observable<Void> {
        loginRepository.getToken(codeVerifier: query.codeVerifier,
                                 authorizationCode: query.authorizationCode)
    }
}
