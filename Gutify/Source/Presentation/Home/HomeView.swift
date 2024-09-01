//
//  HomeView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @ObservedObject var input: HomeViewModel.Input
    @ObservedObject var output: HomeViewModel.Output
    
    private let cancelBag = CancelBag()
    
    private let onTapRoot = PassthroughSubject<Void, Never>()
    private let onTapPush = PassthroughSubject<Void, Never>()
    private let onTapSheet = PassthroughSubject<Void, Never>()
    
    var body: some View {
        BaseView(output: output) {
            Text("Set root")
                .onTapGesture {
                    onTapRoot.send()
                }
            Text("Push")
                .onTapGesture {
                    onTapPush.send()
                }
            Text("Sheet")
                .onTapGesture {
                    onTapSheet.send()
                }
            output.addNavigations
        }
        .navigationTitle("Home")
    }
    
    init(viewModel: HomeViewModel) {
        let input = HomeViewModel.Input(onTapRoot: onTapRoot.asDriver(),
                                          onTapPush: onTapPush.asDriver(),
                                          onTapSheet: onTapSheet.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

#Preview {
    NavigationStack {
        DefaultHomeAssembler.resolve()
    }
}
