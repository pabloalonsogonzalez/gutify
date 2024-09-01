//
//  WelcomeView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI
import Combine

struct WelcomeView: View {
    
    @ObservedObject var input: WelcomeViewModel.Input
    @ObservedObject var output: WelcomeViewModel.Output
    
    private let cancelBag = CancelBag()
    
    private let onTapSignIn = PassthroughSubject<Void, Never>()
    
    var body: some View {
        BaseView(output: output) {
            Text("Sign in")
                .onTapGesture {
                    onTapSignIn.send()
                }
            output.addNavigations
        }
        .navigationTitle("Welcome View")
    }
    
    init(viewModel: WelcomeViewModel) {
        let input = WelcomeViewModel.Input(onTapSignIn: onTapSignIn.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

#Preview {
    DefaultWelcomeAssembler.resolve()
}
