//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol FooAssembler {
    static func resolve() -> FooView
    static func resolve() -> FooViewModel
}

struct DefaultFooAssembler: FooAssembler {
    static func resolve() -> FooView {
        FooView(viewModel: resolve())
    }
    static func resolve() -> FooViewModel {
        FooViewModel()
    }
}
