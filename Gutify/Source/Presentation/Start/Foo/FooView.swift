//
//  FooView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI
import Combine

struct FooView: View {
    
    @ObservedObject var input: FooViewModel.Input
    @ObservedObject var output: FooViewModel.Output
    
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
        .navigationTitle("Foo View")
    }
    
    init(viewModel: FooViewModel) {
        let input = FooViewModel.Input(onTapRoot: onTapRoot.asDriver(),
                                          onTapPush: onTapPush.asDriver(),
                                          onTapSheet: onTapSheet.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
    }
}

#Preview {
    DefaultFooAssembler.resolve()
}
