//
//  TabBarAssembler.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation

protocol TabBarAssembler {
    static func resolve() -> TabBarView
}

struct DefaultTabBarAssembler: TabBarAssembler {
    static func resolve() -> TabBarView {
        TabBarView()
    }
}
