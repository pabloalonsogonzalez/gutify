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
    
    private let initTrigger = PassthroughSubject<Void, Never>()
    private let columns = [GridItem(.flexible()),
                           GridItem(.flexible())]
    
    enum ViewState {
        case loading
        case loaded(tracks: [Track], artists: [Artist], albums: [Album])
    }
    
    var body: some View {
        BaseView(output: output) {
            switch output.viewState {
            case .loading:
                LoaderView()
            case .loaded(let tracks, let artists, let albums):
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        Text("TopTracksTitle")
                            .font(.title)
                            .bold()
                        LazyVGrid(columns: columns, content: {
                            ForEach(tracks, id: \.id) {
                                TopTrackView(track: $0)
                            }
                        })
                        .padding(.bottom, 20)
                        Text("TopArtistsTitle")
                            .font(.title)
                            .bold()
                        ScrollView(.horizontal) {
                            HStack(alignment: .top) {
                                ForEach(artists, id: \.id) {
                                    TopArtistView(artist: $0)
                                }
                            }
                        }
                        Text("NewReleasesTitle")
                            .font(.title)
                            .bold()
                        ScrollView(.horizontal) {
                            HStack(alignment: .top) {
                                ForEach(albums, id: \.id) {
                                    NewReleaseAlbumView(album: $0)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            output.addNavigations
        }
        .navigationTitle("AppName")
    }
    
    init(viewModel: HomeViewModel) {
        let input = HomeViewModel.Input(initTrigger: initTrigger.asDriver())
        output = viewModel.transform(input, cancelBag: cancelBag)
        self.input = input
        initTrigger.send()
    }
}

struct TopTrackView: View {
    private let track: Track
    private let size: CGFloat = 50
    
    init(track: Track) {
        self.track = track
    }
    var body: some View {
        HStack {
            CustomAsyncImage(url: track.album.imageUrl,
                             size: size)
            VStack(alignment: .leading) {
                Text(track.name)
                    .font(.caption)
                    .foregroundStyle(Color("PrimaryColor"))
                Text(track.allArtists)
                    .font(.caption2)
                    .foregroundStyle(Color("GreyColor"))
            }
            Spacer()
        }
        .frame(height: size)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct TopArtistView: View {
    let artist: Artist
    private let size: CGFloat = 100
    
    init(artist: Artist) {
        self.artist = artist
    }
    
    var body: some View {
        VStack {
            CustomAsyncImage(url: artist.imageUrl,
                             size: size)
            .background(Color.white.opacity(0.1))
            .clipShape(Circle())
            Text(artist.name)
                .font(.callout)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: size)
    }
}

struct NewReleaseAlbumView: View {
    let album: Album
    private let size: CGFloat = 100
    
    init(album: Album) {
        self.album = album
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomAsyncImage(url: album.imageUrl,
                             size: size)
            .background(Color.white.opacity(0.1))
//            .clipShape(Circle())
            Text(album.name)
                .font(.caption)
                .foregroundStyle(Color("PrimaryColor"))
            Text(album.allArtists)
                .font(.caption2)
                .foregroundStyle(Color("GreyColor"))
            Spacer()
        }
        .frame(width: size)
    }
}

struct CustomAsyncImage: View {
    let url: URL?
    let size: CGFloat
    init(url: URL?,
         size: CGFloat) {
        self.url = url
        self.size = size
    }
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                } else if phase.error != nil {
                    imageNotAvailable
                        .frame(width: size, height: size)
                } else {
                    ProgressView()
                        .frame(width: size, height: size)
                }
            }
        } else {
            imageNotAvailable
                .frame(width: size, height: size)
        }
    }
    
    private var imageNotAvailable: some View {
        Image(systemName: "xmark.icloud")
            .resizable()
            .scaledToFit()
            .padding(5)
    }
}

#Preview {
    NavigationStack {
        DefaultHomeAssembler.resolve()
    }
}

#Preview {
    TopTrackView(track: Track(id: UUID().uuidString,
                              name: "Titulo canción",
                              artists: [Artist(id: UUID().uuidString,
                                               name: "Artista1"),
                                        Artist(id: UUID().uuidString,
                                               name: "Artista2")],
                              album: Album(id: UUID().uuidString,
                                           name: "Nombre Album",
                                           releaseDate: "2019",
                                           artists: [Artist(id: UUID().uuidString,
                                                            name: "Artista1"),
                                                     Artist(id: UUID().uuidString,
                                                            name: "Artista2")])))
}

#Preview {
    TopArtistView(artist: Artist(id: UUID().uuidString,
                                 name: "Nombre Artista"))
}
