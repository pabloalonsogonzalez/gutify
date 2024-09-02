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
        
        return getAccessToken()
            .flatMap {
                request.addHeaders([BaseRepository.authorization: BaseRepository.bearer + " " + $0])
                return self.executeRequest(request, mapFunction: mapFunction)
            }
            .asObservable()
    }
    
    private func executeRequest<T, S>(_ request: RequestBuilder<T>,
                                      mapFunction: @escaping (T) throws -> (S)) -> Observable<S> {
        var requestTask: RequestTask?
        // Using deferred to let retries (Future returns same result every time)
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
                // TODO NO FUNCIONA
                return self.getRefreshToken()
                    .flatMap { refreshToken in
                        self.executeRequest(AuthAPI.requestRefreshToken(refreshToken: refreshToken),
                                       mapFunction: TokenMapper.transform)
                        .flatMap { token in
                            self.saveToken(token)
                            .flatMap { _ in
                                self.executeRequest(request,
                                               secureRequest: true,
                                               mapFunction: mapFunction)
                            }
                        }
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

extension BaseRepository {

    func getAccessToken() -> Observable<String> {
        loadSecurely(key: DefaultLoginRepository.accessToken)
            .tryMap {
                guard let accessToken = $0 else {
                    throw DefaultLoginRepository.LoginError.notLoged
                }
                return accessToken
            }
            .asObservable()
    }
    
    private func getRefreshToken() -> Observable<String> {
        loadSecurely(key: DefaultLoginRepository.refreshToken)
            .tryMap {
                guard let refreshToken = $0 else {
                    throw DefaultLoginRepository.LoginError.notLoged
                }
                return refreshToken
            }
            .asObservable()
    }
    
    func saveToken(_ token: Token) -> Observable<Void> {
        Publishers.Zip(self.saveSecurely(key: DefaultLoginRepository.accessToken, value: token.accessToken),
                       self.saveSecurely(key: DefaultLoginRepository.refreshToken, value: token.refreshToken))
        .map {_ in}
        .asObservable()
    }

}
