//
//  MainAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol LibraryAssembler {
    static func resolve() -> LibraryView
    static func resolve() -> LibraryViewModel
}

struct DefaultLibraryAssembler: LibraryAssembler {
    static func resolve() -> LibraryView {
        LibraryView(viewModel: resolve())
    }
    static func resolve() -> LibraryViewModel {
        LibraryViewModel(getLibraryUseCase: DefaultMusicDomainAssembler.resolve())
    }
}
