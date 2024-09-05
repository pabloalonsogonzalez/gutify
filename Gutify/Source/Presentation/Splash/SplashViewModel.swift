//
//  SplashViewModel.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import Combine

struct SplashViewModel: BaseViewModel {
    
    final class Input: ObservableObject {
        let initTrigger: Driver<Void>
        let onTapRequestAuthorization: Driver<Void>
        let onAuthorizationDismissed: Driver<Void>
        
        init(initTrigger: Driver<Void>,
             onTapRequestAuthorization: Driver<Void>,
             onAuthorizationDismissed: Driver<Void>) {
            self.initTrigger = initTrigger
            self.onTapRequestAuthorization = onTapRequestAuthorization
            self.onAuthorizationDismissed = onAuthorizationDismissed
        }
    }
    
    final class Output: BaseOutput {
        @Published var isLoading: Bool = true
        @Published var showAuthorization: Bool = false
        @Published var codeReponse: String = ""
        var userAuthorization: UserAuthorization? = nil
    }
    
    private let dependencies: SplashDependencies
    private let checkLogedUserUseCase: CheckLogedUserUseCase
    private let getUserAuthorizationUseCase: GetUserAuthorizationUseCase
    private let getTokenUseCase: GetTokenUseCase
    
    init(dependencies: SplashDependencies,
         checkLogedUserUseCase: CheckLogedUserUseCase,
         getUserAuthorizationUseCase: GetUserAuthorizationUseCase,
         getTokenUseCase: GetTokenUseCase) {
        self.dependencies = dependencies
        self.checkLogedUserUseCase = checkLogedUserUseCase
        self.getUserAuthorizationUseCase = getUserAuthorizationUseCase
        self.getTokenUseCase = getTokenUseCase
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
//        let activityTracker = ActivityTracker(false)
        let errorTracker = ErrorTracker()
        
        if !dependencies.isLogout {
            let animationCount = Timer.publish(every: 1.5, on: .main, in: .default)
                .autoconnect()
                .first()
                .asDriver()
            
            Publishers.Zip(animationCount, input.initTrigger)
                .flatMap { _ in
                    checkLogedUserUseCase
                        .execute()
                        .trackError(errorTracker)
                }
                .sink {
                    output.rootNavigation = .tabBar
                }
                .store(in: cancelBag)
        } else {
            output.isLoading = false
        }
        
        input.onTapRequestAuthorization
            .flatMap {
                output.isLoading = true
                return getUserAuthorizationUseCase
                    .execute()
                    .trackError(errorTracker)
            }
            .sink {
                output.userAuthorization = $0
                output.showAuthorization = true
            }.store(in: cancelBag)
        
        input.onAuthorizationDismissed
            .sink {
                output.isLoading = false
            }
            .store(in: cancelBag)
        
        output.$codeReponse
            .filter { !$0.isEmpty }
            .flatMap { codeResponse in
                output.isLoading = true
                guard let codeVerifier = output.userAuthorization?.codes.codeVerifier else {
                    // TODO
                    return Observable<Void>.fail(DefaultLoginRepository.LoginError.invalidCredentials)
                        .trackError(errorTracker)
                }
                return getTokenUseCase
                    .execute(GetTokenUseCase.Query(codeVerifier: codeVerifier,
                                                   authorizationCode: codeResponse))
                    .trackError(errorTracker)
            }
            .sink {
                output.rootNavigation = .tabBar
            }.store(in: cancelBag)
        
        
        // TODO
        errorTracker.sink {
            if ($0 as? DefaultLoginRepository.LoginError) == .notLoged {
                output.isLoading = false
            }
        }
        .store(in: cancelBag)
        
        return output
    }
}
