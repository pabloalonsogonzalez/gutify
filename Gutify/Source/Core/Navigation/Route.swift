//
//  Screen.swift
//  Gutify
//  All available screens in the app
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case none
    
    case splash
    case tabBar
    case home
    // case aFooView(FooViewDependencies)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .splash:
            DefaultSplashAssembler.resolve()
        case .tabBar:
            DefaultTabBarAssembler.resolve()
        case .home:
            DefaultHomeAssembler.resolve()
        case .none:
            EmptyView()
        }
    }
}
