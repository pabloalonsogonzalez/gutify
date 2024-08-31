//
//  ActivityTracker.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 28/8/24.
//

import Combine
import UIKit

public typealias ActivityTracker = CurrentValueSubject<Bool, Never>

extension Publisher {
    
    public func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        })
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
