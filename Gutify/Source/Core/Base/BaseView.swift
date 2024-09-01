//
//  BaseView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI

struct BaseView<Content:View>: View {
    @ObservedObject var output: BaseOutput
    
    let content: Content
    
    @EnvironmentObject var presentedScreen: PresentedScreen
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(output: BaseOutput,
         @ViewBuilder content: () -> Content) {
        self.output = output
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        // Navigation -> change root screen
        .onChange(of: output.rootNavigation) { _, newValue in
            presentedScreen.currentScreen = newValue
        }
        .onChange(of: output.shouldDismiss) {
            if output.shouldDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
