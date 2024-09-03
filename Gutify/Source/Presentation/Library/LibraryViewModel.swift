//
//  LibraryViewModel.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import Foundation
import Combine

struct LibraryViewModel: BaseViewModel {
    
    final class Input: ObservableObject {
        let initTrigger: Driver<Void>
        @Published var searchText: String = ""
        @Published var selectedFilter: FilterTab.FilterTabData? = nil
        var items: [Searchable] = []
        
        init(initTrigger: Driver<Void>) {
            self.initTrigger = initTrigger
        }
    }
    
    final class Output: BaseOutput {
        @Published var viewState: LibraryView.ViewState = .loading
    }
    
    private let getLibraryUseCase: GetLibraryUseCase
    
    init(getLibraryUseCase: GetLibraryUseCase) {
        self.getLibraryUseCase = getLibraryUseCase
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let errorTracker = ErrorTracker()
        
        input.initTrigger
            .flatMap {
                getLibraryUseCase.execute()
                    .trackError(errorTracker)
            }
            .sink {
                input.items = $0.sorted(by: { lhs, rhs in lhs.name.caseInsensitiveCompare(rhs.name) == .orderedAscending })
                output.viewState = .loaded(items: input.items)
            }
            .store(in: cancelBag)
        
        input.$searchText
            .sink {
                filter(input: input, searchText: $0, filterData: input.selectedFilter, output: output)
            }
            .store(in: cancelBag)
        
        input.$selectedFilter
            .sink {
                filter(input: input, searchText: input.searchText, filterData: $0, output: output)
            }
            .store(in: cancelBag)
        
        // TODO
        errorTracker.sink {
            print("\($0)")
        }
        .store(in: cancelBag)
        
        
        return output
    }
    
    private func filter(input: Input, searchText: String, filterData: FilterTab.FilterTabData?, output: Output) {
        output.viewState = .loaded(items: input.items
            .filter {
                guard let filter = filterData else {
                    return true
                }
                switch filter {
                case .tracks:
                    return $0 is Track
                case .albums:
                    return $0 is Album
                case .playlists:
                    return $0 is Playlist
                case .artists:
                    return $0 is Artist
                }
            }
            .filter {
                guard !searchText.isEmpty else {
                    return true
                }
                return $0.name.contains(searchText)
            })
    }
}
