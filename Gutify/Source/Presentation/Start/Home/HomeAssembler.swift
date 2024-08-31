//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol HomeAssembler {
    static func resolve() -> HomeView
    static func resolve() -> HomeViewModel
}

struct DefaultHomeAssembler: HomeAssembler {
    static func resolve() -> HomeView {
        HomeView(viewModel: resolve())
    }
    static func resolve() -> HomeViewModel {
        HomeViewModel()
    }
}
