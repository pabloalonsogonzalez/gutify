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
    
    case splash(SplashDependencies)
    case tabBar
    case home
    case library
    case profile
    // case aFooView(FooViewDependencies)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .splash(let dependencies):
            DefaultSplashAssembler.resolve(dependencies: dependencies)
        case .tabBar:
            DefaultTabBarAssembler.resolve()
        case .home:
            DefaultHomeAssembler.resolve()
        case .library:
            DefaultLibraryAssembler.resolve()
        case .profile:
            DefaultProfileAssembler.resolve()
        case .none:
            EmptyView()
        }
    }
    
//    var equatableValue: String {
//        String(describing: self)
//    }
//    
//    static func == (lhs: Route, rhs: Route) -> Bool {
//        lhs.equatableValue == rhs.equatableValue
//    }
}
