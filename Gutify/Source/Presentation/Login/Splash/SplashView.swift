//
//  SplashView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI
import Combine

struct SplashView: View {
    
    @ObservedObject var input: SplashViewModel.Input
    @ObservedObject var output: SplashViewModel.Output
    
    private let cancelBag = CancelBag()
    
    private let initTrigger = PassthroughSubject<Void, Never>()
    private let onTapRequestAuthorization = PassthroughSubject<Void, Never>()
    private let onAuthorizationDismissed = PassthroughSubject<Void, Never>()
    
    var body: some View {
        BaseView(output: output) {
            if output.isLoading {
                ZStack {
                    Color.red
                    ProgressView()
                }
            } else {
                Text("Request permission")
                    .onTapGesture {
                        onTapRequestAuthorization.send()
                    }
            }
            output.addNavigations
        }
        .sheet(isPresented: $output.showAuthorization, content: {
            if let url = output.userAuthorization?.url {
                WebView(url: url,
                        showWebView: $output.showAuthorization,
                        codeReponse: $output.codeReponse)
            }
        })
        .onChange(of: output.showAuthorization, { _, newValue in
            if !newValue {
                onAuthorizationDismissed.send()
            }
        })
    }
    
    init(viewModel: SplashViewModel) {
        let input = SplashViewModel.Input(initTrigger: initTrigger.asDriver(),
                                          onTapRequestAuthorization: onTapRequestAuthorization.asDriver(),
                                          onAuthorizationDismissed: onAuthorizationDismissed.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
        initTrigger.send()
    }
}

#Preview {
    DefaultSplashAssembler.resolve()
}
