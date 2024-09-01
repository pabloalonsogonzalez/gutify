//
//  WelcomeViewModel.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import Combine

struct WelcomeViewModel: BaseViewModel {
    
    final class Input: ObservableObject {
        let onTapSignIn: Driver<Void>
        
        init(onTapSignIn: Driver<Void>) {
            self.onTapSignIn = onTapSignIn
        }
    }
    
    final class Output: BaseOutput {
        
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        input.onTapSignIn
            .sink {
                
            }
            .store(in: cancelBag)
        return output
    }
}
