//
//  RootView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI

class PresentedScreen: ObservableObject {
    @Published var currentScreen: Route = .splash
}

struct RootView: View {
    @EnvironmentObject var presentedScreen: PresentedScreen
    
    var body: some View {
//        NavigationStack {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            presentedScreen.currentScreen.view
        }
//        }
    }
}

#Preview {
    RootView().environmentObject(PresentedScreen())
}
