//
//  PlaylistMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

final class PlaylistMapper: BaseMapper<SimplifiedPlaylistObjectDTO, Playlist> {
    
    override class func transform(_ dataModel: SimplifiedPlaylistObjectDTO) throws -> Playlist {
        var url: URL?
        if let urlString = dataModel.images.first?.url {
            url = URL(string: urlString)
        }
        return Playlist(id: dataModel.id,
                        name: dataModel.name,
                        imageUrl: url,
                        tracksNumber: dataModel.tracks.total)
    }
}
