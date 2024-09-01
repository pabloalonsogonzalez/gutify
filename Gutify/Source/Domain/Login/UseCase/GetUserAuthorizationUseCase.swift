//
//  StartAppUseCase.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

struct GetUserAuthorizationUseCase: UseCase {
    
    struct Query: UseCaseQuery {}
    
    let loginRepository: LoginRepository
    
    func buildObservable(_ query: Query) -> Observable<UserAuthorization> {
        loginRepository.requestUserAuthorization()
    }
}
