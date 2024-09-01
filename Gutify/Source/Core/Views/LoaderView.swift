//
//  LoaderView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 1/9/24.
//

import SwiftUI

struct LoaderView: View {
    @State private var degrees = 0.0
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            Image("SpotifyIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .onAppear() {
                    withAnimation(Animation
                        .bouncy
                        .repeatForever()) {
                        degrees += 360
                    }
                }
                .rotationEffect(.degrees(degrees))
            
        }
    }
}

#Preview {
    LoaderView()
}
