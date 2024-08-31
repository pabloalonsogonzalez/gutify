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
    
    private let onTapRoot = PassthroughSubject<Void, Never>()
    private let onTapPush = PassthroughSubject<Void, Never>()
    private let onTapSheet = PassthroughSubject<Void, Never>()
    
    var body: some View {
        BaseView(output: output) {
            Text("Set root home")
                .onTapGesture {
                    onTapRoot.send()
                }
            Text("Push home")
                .onTapGesture {
                    onTapPush.send()
                }
            Text("Sheet foo")
                .onTapGesture {
                    onTapSheet.send()
                }
            output.addNavigations
        }
        .navigationTitle("Splash")
    }
    
    init(viewModel: SplashViewModel) {
        let input = SplashViewModel.Input(onTapRoot: onTapRoot.asDriver(),
                                          onTapPush: onTapPush.asDriver(),
                                          onTapSheet: onTapSheet.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

#Preview {
    DefaultSplashAssembler.resolve()
}
