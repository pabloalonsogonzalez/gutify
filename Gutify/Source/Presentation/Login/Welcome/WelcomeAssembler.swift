//
//  WelcomeAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol WelcomeAssembler {
    static func resolve() -> WelcomeView
    static func resolve() -> WelcomeViewModel
}

struct DefaultWelcomeAssembler: WelcomeAssembler {
    static func resolve() -> WelcomeView {
        WelcomeView(viewModel: resolve())
    }
    static func resolve() -> WelcomeViewModel {
        WelcomeViewModel()
    }
}
