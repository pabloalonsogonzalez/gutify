//
//  CustomAsyncView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 3/9/24.
//

import SwiftUI

struct CustomAsyncImage: View {
    let url: URL?
    let size: CGFloat
    init(url: URL?,
         size: CGFloat) {
        self.url = url
        self.size = size
    }
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                } else if phase.error != nil {
                    imageNotAvailable
                        .frame(width: size, height: size)
                } else {
                    ProgressView()
                        .frame(width: size, height: size)
                }
            }
        } else {
            imageNotAvailable
                .frame(width: size, height: size)
        }
    }
    
    private var imageNotAvailable: some View {
        Image(systemName: "xmark.icloud")
            .resizable()
            .scaledToFit()
            .padding(5)
    }
}

#Preview {
    CustomAsyncImage(url: nil, size: 50)
}
