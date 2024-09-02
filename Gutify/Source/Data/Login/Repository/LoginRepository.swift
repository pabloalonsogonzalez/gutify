//
//  LoginRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

protocol LoginRepository {
    func checkUserLoged() -> Observable<Void>
    func requestUserAuthorization() -> Observable<UserAuthorization>
    func getToken(codeVerifier: String, authorizationCode: String) -> Observable<Void>
    func removeToken() -> Observable<Void>
}

class DefaultLoginRepository: BaseRepository, LoginRepository {
    
    enum LoginError: Error {
        case notLoged
        case invalidCredentials
    }
    
    static let accessToken = "Access_Token"
    static let refreshToken = "Refresh_Token"
    
    func checkUserLoged() -> Observable<Void> {
        getAccessToken()
            .map { _ in }
            .asObservable()
    }
    
    func requestUserAuthorization() -> Observable<UserAuthorization> {
        PKCECodes.generate()
            .tryMap {
                var urlComponents = URLComponents(string: AuthAPI.basePath + "/authorize")
                let queryItems = [
                    URLQueryItem(name: "response_type", value: "code"),
                    URLQueryItem(name: "client_id", value: GutifyConstants.clientID),
                    URLQueryItem(name: "redirect_uri", value: GutifyConstants.redirectUri),
                    URLQueryItem(name: "show_dialog", value: String(true)),
                    URLQueryItem(name: "scope", value: "user-top-read user-library-read"),
                    URLQueryItem(name: "code_challenge_method", value: "S256"),
                    URLQueryItem(name: "code_challenge", value: $0.codeChallenge),
                ]
                urlComponents?.queryItems = queryItems
                guard let url = urlComponents?.url else { throw LoginError.invalidCredentials }
                return UserAuthorization(url: url, codes: $0)
            }
            .asObservable()
    }
    
    func getToken(codeVerifier: String, authorizationCode: String) -> Observable<Void> {
        executeRequest(AuthAPI.requestAccessToken(codeVerifier: codeVerifier,
                                                  authorizationCode: authorizationCode),
                       secureRequest: false,
                       mapFunction: TokenMapper.transform)
        .flatMap { token in
            self.saveToken(token)
        }
        .asObservable()
    }
    
    func removeToken() -> Observable<Void> {
        Publishers.Zip(self.removeSecurely(key: DefaultLoginRepository.accessToken),
                       self.removeSecurely(key: DefaultLoginRepository.refreshToken))
        .map {_ in}
        .asObservable()
    }
    
}
