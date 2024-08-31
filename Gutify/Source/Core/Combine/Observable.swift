//
//  Driver.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 28/8/24.
//
import Combine

typealias Observable<T> = AnyPublisher<T, Error>

extension Publisher {

    func asObservable() -> Observable<Output> {
        mapError { $0 }
            .eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> Observable<Output> {
        Just(output)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    static func empty() -> Observable<Output> {
        Empty().eraseToAnyPublisher()
    }

    static func fail(_ error: Failure) -> Observable<Output> {
        Fail(error: error).eraseToAnyPublisher()
    }

}
