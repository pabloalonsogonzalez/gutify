//
//  HomeViewModel.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import Combine

struct HomeViewModel: BaseViewModel {
    
    final class Input: ObservableObject {
        let onTapRoot: Driver<Void>
        let onTapPush: Driver<Void>
        let onTapSheet: Driver<Void>
        
        init(onTapRoot: Driver<Void>,
             onTapPush: Driver<Void>,
             onTapSheet: Driver<Void>) {
            self.onTapRoot = onTapRoot
            self.onTapPush = onTapPush
            self.onTapSheet = onTapSheet
        }
    }
    
    final class Output: BaseOutput {
        
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        return output
    }
}
