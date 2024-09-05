//
//  ProfileViewModel.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import Combine

struct ProfileViewModel: BaseViewModel {
    
    final class Input: ObservableObject {
        let initTrigger: Driver<Void>
        let logoutTrigger: Driver<Void>
        
        init(initTrigger: Driver<Void>,
             logoutTrigger: Driver<Void>) {
            self.initTrigger = initTrigger
            self.logoutTrigger = logoutTrigger
        }
    }
    
    final class Output: BaseOutput {
        @Published var viewState: ProfileView.ViewState = .loading
    }
    
    private let getProfileUseCase: GetProfileUseCase
    private let removeTokenUseCase: RemoveTokenUseCase
    
    init(getProfileUseCase: GetProfileUseCase,
         removeTokenUseCase: RemoveTokenUseCase) {
        self.getProfileUseCase = getProfileUseCase
        self.removeTokenUseCase = removeTokenUseCase
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let errorTracker = ErrorTracker()
        
        input.initTrigger
            .flatMap {
                getProfileUseCase
                    .execute()
                    .trackError(errorTracker)
            }
            .sink {
                output.viewState = .loaded(profile: $0)
            }
            .store(in: cancelBag)
        
        input.logoutTrigger
            .flatMap {
                removeTokenUseCase
                    .execute()
                    .trackError(errorTracker)
            }
            .sink {
                output.rootNavigation = .splash(SplashDependencies(isLogout: true))
            }
            .store(in: cancelBag)
        
        // TODO
        errorTracker.sink {
            print($0)
        }
        .store(in: cancelBag)
    
        return output
    }
}
