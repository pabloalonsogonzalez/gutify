//
//  MusicRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

protocol MusicRepository {
    func getUserTopTracks() -> Observable<[Track]>
    func getUserTopArtists() -> Observable<[Artist]>
    func getNewReleases() -> Observable<[Album]>
}

class DefaultMusicRepository: BaseRepository, MusicRepository {
    
    enum MusicError: Error {
    }
    
    func getUserTopTracks() -> Observable<[Track]> {
        executeRequest(MusicAPI.getUsersTopTracksWithRequestBuilder(limit: 10)) {
            try TrackMapper.listTransform($0.items)
        }
        .asObservable()
    }
    
    func getUserTopArtists() -> Observable<[Artist]> {
        executeRequest(MusicAPI.getUsersTopArtistsWithRequestBuilder(limit: 10)) {
            try ArtistMapper.listTransform($0.items)
        }
    }
    
    func getNewReleases() -> Observable<[Album]> {
        executeRequest(MusicAPI.getNewReleasesWithRequestBuilder(limit: 10)) {
            try SimplifiedAlbumMapper.listTransform($0.albums.items)
        }
    }
}
