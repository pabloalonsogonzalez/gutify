//
//  BaseViewModel.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import Combine
import SwiftUI

class BaseOutput: ObservableObject {
    
    @Published var alertMessage = AlertMessage()
//     Navigation
    @Published var rootNavigation: Route = .none
    @Published var pushNavigation: Route = .none
    @Published var sheetNavigation: Route = .none
    @Published var shouldDismiss: Bool = false
    
//     ADD THIS IN THE VIEW YOU WANT TO PUSH / SHEET NAVIGATE AS: output.addNavigations.
//     transform clausures returns the new presented view, to inject environment objects
    @ViewBuilder
    func addNavigations(pushViewTransform: (Route) -> some View,
                        sheetViewTransform: (Route) -> some View) -> some View {
        addPushNavigations(view: pushViewTransform(pushNavigation))
        addSheetNavigations(view: sheetViewTransform(sheetNavigation))
    }
    
    @ViewBuilder
    func addNavigations(pushViewTransform: (Route) -> some View) -> some View {
        addPushNavigations(view: pushViewTransform(pushNavigation))
        addSheetNavigations(view: sheetNavigation.view)
    }
    
    @ViewBuilder
    func addNavigations(sheetViewTransform: (Route) -> some View) -> some View {
        addPushNavigations(view: pushNavigation.view)
        addSheetNavigations(view: sheetViewTransform(sheetNavigation))
    }
    
    @ViewBuilder
    var addNavigations : some View {
        addPushNavigations(view: pushNavigation.view)
        addSheetNavigations(view: sheetNavigation.view)
    }
    
    @ViewBuilder
    private func addPushNavigations(view: some View) -> some View {
        VStack { }
            .navigationDestination(isPresented: .init(get: { self.pushNavigation != .none },
                                                   set: { _ in self.pushNavigation = .none })) {
            view
        }
    }
    
    @ViewBuilder
    private func addSheetNavigations(view: some View) -> some View {
        VStack {}
            .sheet(
                isPresented: .init(
                    get: { self.sheetNavigation != .none },
                    set: { _ in self.sheetNavigation = .none }
                ),
                content: {
                    NavigationStack {
                        view
                    }
                }
            )
    }

}

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output: BaseOutput
    
    func transform(_ input: Input,
                   cancelBag: CancelBag) -> Output
}
