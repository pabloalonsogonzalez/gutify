//
//  TrackMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

final class TrackMapper: BaseMapper<TrackObjectDTO, Track> {
    
    override class func transform(_ dataModel: TrackObjectDTO) throws -> Track {
        Track(id: dataModel.id,
              name: dataModel.name,
              artists: try ArtistMapper.listTransform(dataModel.artists),
              album: try SimplifiedAlbumMapper.transform(dataModel.album))
    }
}
