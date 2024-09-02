//
//  LibraryView.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 27/8/24.
//

import SwiftUI
import Combine

struct LibraryView: View {
    
    @ObservedObject var input: LibraryViewModel.Input
    @ObservedObject var output: LibraryViewModel.Output
    
    private let cancelBag = CancelBag()
    
    private let initTrigger = PassthroughSubject<Void, Never>()
    @State var isShowingSearchBar: Bool = false
    
    enum ViewState {
        case loading
        case loaded(items: [Searchable])
    }
    
    var body: some View {
        BaseView(output: output) {
            switch output.viewState {
            case .loading:
                LoaderView()
            case .loaded(let items):
                VStack {
                    SearchBar(isShowing: $isShowingSearchBar,
                              searchText: $input.searchText,
                              selectedFilter: $input.selectedFilter)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    ScrollView {
                        LazyVStack {
                            ForEach(items, id: \.id) {
                                Text($0.name)
                            }
                        }
                    }
                }
            }
            
            output.addNavigations
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        isShowingSearchBar = true
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .navigationTitle("AppName")
    }
    
    init(viewModel: LibraryViewModel) {
        let input = LibraryViewModel.Input(initTrigger: initTrigger.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
        initTrigger.send()
    }
}

struct SearchBar: View {
    
    @Binding var isShowing: Bool
    @Binding var searchText: String
    @Binding var selectedFilter: FilterTab.FilterTabData?
    var filterTabs: [FilterTab.FilterTabData] {
        FilterTab.FilterTabData.allCases
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if isShowing {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("SearchBarPlaceHolder", text: $searchText)
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                        }
                    }
                    .padding(5)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    Button("SearchBarCancelButton") {
                        withAnimation {
                            searchText = ""
                            isShowing = false
                        }
                    }
                }
                .padding(.bottom, 5)
            }
            HStack {
                ForEach(filterTabs, id: \.self) { data in
                    FilterTab(filterTabData: data, isSelected: Binding(get: {
                        selectedFilter == data
                    }, set: { newValue in
                        selectedFilter = newValue ? data : nil
                    }))
                }
                Spacer()
            }
        }
    }
}

struct FilterTab: View {
    enum FilterTabData: LocalizedStringResource, CaseIterable {
        case tracks = "FilterTabTracks"
        case albums = "FilterTabAlbums"
        case playlists = "FilterTabPlaylists"
        case artists = "FilterTabArtists"
    }
    
    var filterTabData: FilterTabData
    @Binding var isSelected: Bool
//    var isSelected: Bool
    
    var body: some View {
        Text(String(localized: filterTabData.rawValue))
            .foregroundStyle(isSelected ? .white : .black)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isSelected ? Color("GreenColor") : Color("GreyColor"))
            .clipShape(Capsule())
            .onTapGesture {
                isSelected.toggle()
            }
    }
}


#Preview {
    NavigationStack {
        DefaultLibraryAssembler.resolve()
    }
}
