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
        let initTrigger: Driver<Void>
        
        init(initTrigger: Driver<Void>) {
            self.initTrigger = initTrigger
        }
    }
    
    final class Output: BaseOutput {
        @Published var viewState: HomeView.ViewState = .loading
    }
    
    private let getUserTopTracksUseCase: GetUserTopTracksUseCase
    private let getUserTopArtistsUseCase: GetUserTopArtistsUseCase
    
    init(getUserTopTracksUseCase: GetUserTopTracksUseCase,
         getUserTopArtistsUseCase: GetUserTopArtistsUseCase) {
        self.getUserTopTracksUseCase = getUserTopTracksUseCase
        self.getUserTopArtistsUseCase = getUserTopArtistsUseCase
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let errorTracker = ErrorTracker()
        
        input.initTrigger
            .flatMap {
                Publishers.Zip(getUserTopTracksUseCase.execute(),
                                 getUserTopArtistsUseCase.execute())
                .trackError(errorTracker)
            }
            .sink {
                output.viewState = .loaded(tracks: $0, artists: $1)
            }
            .store(in: cancelBag)
        
        // TODO
        errorTracker.sink {
            print("\($0)")
        }
        .store(in: cancelBag)
        
        
        return output
    }
}
