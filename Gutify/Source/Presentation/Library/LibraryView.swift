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
                    if !items.isEmpty {
                        ScrollView {
                            LazyVStack {
                                ForEach(items, id: \.id) {
                                    LibraryItemView(searchable: $0)
                                }
                            }
                        }
                    } else {
                        VStack {
                            Spacer()
                            Text("SearchListNoResultsTitle")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("SearchListNoResultsMessage")
                                .font(.caption)
                                .foregroundStyle(Color("GreyColor"))
                            Spacer()
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

struct LibraryItemView: View {
    var searchable: Searchable
    var url: URL? {
        switch searchable {
        case let playlist as Playlist:
            return playlist.imageUrl
        case let track as Track:
            return track.album.imageUrl
        case let album as Album:
            return album.imageUrl
        case let artist as Artist:
            return artist.imageUrl
        default:
            return nil
        }
    }
    var title: String {
        return searchable.name
    }
    var subtitle: String {
        switch searchable {
        case let playlist as Playlist:
            return String(localized: "LibraryItemPlaylistSubtitle \(playlist.tracksNumber)")
        case let track as Track:
            return track.allArtists
        case let album as Album:
            return album.allArtists
        case let artist as Artist:
            guard let followers = artist.followers else { return ""}
            return String(localized: "\(followers) LibraryItemArtistSubtitle")
        default:
            return ""
        }
    }
    
    @ViewBuilder
    var image: some View {
        let customImage = CustomAsyncImage(url: url,
                                           size: size)
        switch searchable {
        case is Track:
            customImage
                .clipShape(RoundedRectangle(cornerRadius: 5))
        case is Artist:
            customImage
                .clipShape(Circle())
        default:
            customImage
        }
    }
    private let size = 50.0
    init(searchable: Searchable) {
        self.searchable = searchable
    }
    
    var body: some View {
        HStack {
            image
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color("PrimaryColor"))
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(Color("GreyColor"))
            }
            Spacer()
        }
        .frame(height: size)
        .frame(maxWidth: .infinity)
        .padding(5)
    }
}

#Preview {
    NavigationStack {
        DefaultLibraryAssembler.resolve()
    }
}
