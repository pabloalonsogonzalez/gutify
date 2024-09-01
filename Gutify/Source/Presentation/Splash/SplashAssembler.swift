//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol SplashAssembler {
    static func resolve() -> SplashView
    static func resolve() -> SplashViewModel
}

struct DefaultSplashAssembler: SplashAssembler {

    static func resolve() -> SplashView {
        SplashView(viewModel: resolve())
    }
    static func resolve() -> SplashViewModel {
        SplashViewModel(checkLogedUserUseCase: DefaultLoginDomainAssembler.resolve(),
                        getUserAuthorizationUseCase: DefaultLoginDomainAssembler.resolve(),
                        getTokenUseCase: DefaultLoginDomainAssembler.resolve())
    }
}
