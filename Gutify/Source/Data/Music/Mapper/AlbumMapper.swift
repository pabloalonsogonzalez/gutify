//
//  AlbumMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

final class AlbumMapper: BaseMapper<AlbumObjectDTO, Album> {

    override class func transform(_ dataModel: AlbumObjectDTO) throws -> Album {
        var url: URL?
        if let urlString = dataModel.images.first?.url {
            url = URL(string: urlString)
        }
        return Album(id: dataModel.id,
              name: dataModel.name,
              imageUrl: url,
              releaseDate: dataModel.releaseDate,
              artists: try SimplifiedArtistMapper.listTransform(dataModel.artists))
    }
}

final class SimplifiedAlbumMapper: BaseMapper<SimplifiedAlbumObjectDTO, Album> {
    
    override class func transform(_ dataModel: SimplifiedAlbumObjectDTO) throws -> Album {
        var url: URL?
        if let urlString = dataModel.images.first?.url {
            url = URL(string: urlString)
        }
        return Album(id: dataModel.id,
              name: dataModel.name,
              imageUrl: url,
              releaseDate: dataModel.releaseDate,
              artists: try SimplifiedArtistMapper.listTransform(dataModel.artists))
    }
}
