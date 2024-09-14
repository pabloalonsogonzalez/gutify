//
//  BaseRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine
import KeychainSwift

class BaseRepository {
    
    lazy var keychain: KeychainSwift = {
        KeychainSwift()
    }()
    
    private static let bearer = "Bearer"
    private static let authorization = "Authorization"
    private static let expiredTokenStatusCode = 401

    func executeRequest<T, S>(_ request: RequestBuilder<T>,
                              secureRequest: Bool = true,
                              mapFunction: @escaping (T) throws -> (S)) -> Observable<S> {
        guard secureRequest else {
            return executeRequest(request,
                                  mapFunction: mapFunction)
        }
        
        return Authenticator.shared.getAccessToken()
            .flatMap {
                request.addHeaders([BaseRepository.authorization: BaseRepository.bearer + " " + $0])
                return self.executeRequest(request, mapFunction: mapFunction)
            }
            .asObservable()
    }
    
    private func executeRequest<T, S>(_ request: RequestBuilder<T>,
                                      mapFunction: @escaping (T) throws -> (S)) -> Observable<S> {
        var requestTask: RequestTask?
        return Deferred {
            Future<T, Error> { promise in
                requestTask = request.execute(OpenAPIClientAPI.apiResponseQueue) { result in
                    switch result {
                    case let .success(response):
                        promise(.success(response.body))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
            }
            .handleEvents(receiveCancel: {
                requestTask?.cancel()
            })
            .tryMap(mapFunction)
            .tryCatch {
                guard let errorResponse = $0 as? ErrorResponse,
                      errorResponse.code == BaseRepository.expiredTokenStatusCode else {
                    throw $0
                }
                return Authenticator.shared.refreshToken()
                    .flatMap {
                        self.executeRequest(request,
                                       secureRequest: true,
                                       mapFunction: mapFunction)
                    }
            }
        }
        .asObservable()
    }
}

extension BaseRepository {

    func saveSecurely(key: String, value: String) -> Observable<String> {
        Deferred {
            Future<String, Never> { promise in
                self.keychain.set(value, forKey: key)
                promise(.success((value)))
            }
        }
        .asObservable()
    }

    func loadSecurely(key: String) -> Observable<String?> {
        Deferred {
            Future<String?, Never> { promise in
                promise(.success((self.keychain.get(key))))
            }
        }
        .asObservable()
    }

    func removeSecurely(key: String) -> Observable<Void> {
        Deferred {
            Future<Void, Never> { promise in
                self.keychain.delete(key)
                promise(.success(()))
            }
        }
        .asObservable()
    }
}

class Authenticator {
    static let shared = Authenticator()
    private let loginRepository: DefaultLoginRepository
    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")
    
    private var refreshObservable: Observable<Void>?
    private init() {
        loginRepository = DefaultLoginRepository()
    }
    
    func getAccessToken() -> Observable<String> {
        loginRepository.loadSecurely(key: DefaultLoginRepository.accessToken)
            .tryMap {
                guard let accessToken = $0 else {
                    throw LoginError.notLoged
                }
                return accessToken
            }
            .asObservable()
    }
    
    func refreshToken() -> Observable<Void> {
        queue.sync { [weak self] in
            guard let self = self else { return Observable<Void>.fail(LoginError.notLoged) }
            // Currently refreshing token
            if let refreshObservable = self.refreshObservable {
                return refreshObservable
            }
            
            let refreshObservable = getRefreshToken()
                .flatMap { refreshToken in
                    self.loginRepository.executeRequest(AuthAPI.requestRefreshToken(refreshToken: refreshToken),
                                                        secureRequest: false,
                                   mapFunction: TokenMapper.transform)
                }
                .flatMap { token -> Observable<Void> in
                    self.refreshObservable = nil
                    return self.saveToken(token)
                }
                .share()
                .asObservable()
            self.refreshObservable = refreshObservable
            return refreshObservable
        }
    }
    
    private func getRefreshToken() -> Observable<String> {
        loginRepository.loadSecurely(key: DefaultLoginRepository.refreshToken)
            .tryMap {
                guard let refreshToken = $0 else {
                    throw LoginError.notLoged
                }
                return refreshToken
            }
            .asObservable()
    }
    
    func saveToken(_ token: Token) -> Observable<Void> {
        Publishers.Zip(loginRepository.saveSecurely(key: DefaultLoginRepository.accessToken, value: token.accessToken),
                       loginRepository.saveSecurely(key: DefaultLoginRepository.refreshToken, value: token.refreshToken))
        .map {_ in}
        .asObservable()
    }
}
