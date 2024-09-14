//
//  LoginGateway.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 14/9/24.
//

import Foundation

protocol LoginRepository {
    func checkUserLoged() -> Observable<Void>
    func requestUserAuthorization() -> Observable<UserAuthorization>
    func getToken(codeVerifier: String, authorizationCode: String) -> Observable<Void>
    func removeToken() -> Observable<Void>
}
