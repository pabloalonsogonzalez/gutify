//
//  ErrorTracker.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 28/8/24.
//

import Combine
import Foundation

public typealias ErrorTracker = PassthroughSubject<Error, Never>

extension Publisher {
    
    func trackError(_ errorTracker: ErrorTracker) -> Driver<Output> {
        handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send(error)
            }
        })
            .asDriver()
    }
}
