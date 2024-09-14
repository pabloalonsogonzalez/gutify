//
//  MusicRepository.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine

class DefaultMusicRepository: BaseRepository, MusicRepository {
    
    func getUserTopTracks() -> Observable<[Track]> {
        executeRequest(MusicAPI.getUsersTopTracksWithRequestBuilder(limit: 10)) {
            try TrackMapper.listTransform($0.items)
        }
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
    
    func getSavedPlaylists() -> Observable<[Playlist]> {
        executeRequest(MusicAPI.getAListOfCurrentUsersPlaylistsWithRequestBuilder()) {
            try PlaylistMapper.listTransform($0.items)
        }
    }
    
    func getSavedAlbums() -> Observable<[Album]> {
        executeRequest(MusicAPI.getUsersSavedAlbumsWithRequestBuilder()) { savedAlbums in
            try AlbumMapper.listTransform(savedAlbums.items.map{ $0.album })
        }
    }
    
    func getSavedTracks() -> Observable<[Track]> {
        executeRequest(MusicAPI.getUsersSavedTracksWithRequestBuilder()) { savedTracks in
            try TrackMapper.listTransform(savedTracks.items.map{ $0.track })
        }
    }
    
    func getFollowedArtists() -> Observable<[Artist]> {
        executeRequest(MusicAPI.getFollowedWithRequestBuilder()) {
            try ArtistMapper.listTransform($0.artists.items)
        }
    }
}
