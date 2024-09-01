//
//  GutifyApp.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI

@main
struct GutifyApp: App {
    @State var presentedScreen = PresentedScreen()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(presentedScreen)
        }
    }
}
