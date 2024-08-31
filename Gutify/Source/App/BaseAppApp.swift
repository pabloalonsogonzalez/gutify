//
//  GutifyApp.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI

@main
struct GutifyApp: App {
    var body: some Scene {
        let presentedScreen = PresentedScreen()
        WindowGroup {
            RootView()
                .environmentObject(presentedScreen)
        }
    }
}
