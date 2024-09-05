//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

struct SplashDependencies: Hashable {
    var isLogout: Bool
}

protocol SplashAssembler {
    static func resolve(dependencies: SplashDependencies) -> SplashView
    static func resolve(dependencies: SplashDependencies) -> SplashViewModel
}

struct DefaultSplashAssembler: SplashAssembler {

    static func resolve(dependencies: SplashDependencies) -> SplashView {
        SplashView(viewModel: resolve(dependencies: dependencies))
    }
    static func resolve(dependencies: SplashDependencies) -> SplashViewModel {
        SplashViewModel(dependencies: dependencies,
                        checkLogedUserUseCase: DefaultLoginDomainAssembler.resolve(),
                        getUserAuthorizationUseCase: DefaultLoginDomainAssembler.resolve(),
                        getTokenUseCase: DefaultLoginDomainAssembler.resolve())
    }
}
