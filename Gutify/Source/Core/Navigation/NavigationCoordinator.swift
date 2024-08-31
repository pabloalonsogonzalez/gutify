//
//  NavigationCoordinator.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 30/8/24.
//

import Foundation
import SwiftUI


class NavigationCoordinator: ObservableObject {
    var routes: [Route] = []
    
    init(root: Route) {
        routes = [root]
    }
    
    func push(_ route: Route) {
        routes.append(route)
    }
    
    func pop() {
        routes.removeLast()
    }
    
    func popTo(_ route: Route) {
        guard let index = routes.firstIndex(where: {$0 == route}) else { return }
        routes = Array(routes.prefix(upTo: index + 1))
    }
    
    func popToRoot() {
        routes.removeLast(routes.count)
    }
}
