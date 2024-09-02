//
//  TrackMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

final class ArtistMapper: BaseMapper<ArtistObjectDTO, Artist> {
    
    override class func transform(_ dataModel: ArtistObjectDTO) throws -> Artist {
        var url: URL?
        if let urlString = dataModel.images?.first?.url {
            url = URL(string: urlString)
        }
        return Artist(id: dataModel.id,
               name: dataModel.name,
               imageUrl: url,
               genres: dataModel.genres,
               followers: dataModel.followers?.total)
    }
}

final class SimplifiedArtistMapper: BaseMapper<SimplifiedArtistObjectDTO, Artist> {
    
    override class func transform(_ dataModel: SimplifiedArtistObjectDTO) throws -> Artist {
        Artist(id: dataModel.id,
               name: dataModel.name)
    }
}
