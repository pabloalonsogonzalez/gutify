//
//  MusicRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

protocol MusicRepository {
    // MARK: HOME
    func getUserTopTracks() -> Observable<[Track]>
    func getUserTopArtists() -> Observable<[Artist]>
    func getNewReleases() -> Observable<[Album]>
    
    // MARK: LIBRARY
    func getSavedPlaylists() -> Observable<[Playlist]>
    func getSavedAlbums() -> Observable<[Album]>
    func getSavedTracks() -> Observable<[Track]>
    func getFollowedArtists() -> Observable<[Artist]>
}

enum MusicError: Error {
}
