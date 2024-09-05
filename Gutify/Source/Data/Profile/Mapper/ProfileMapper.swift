//
//  ProfileMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

final class ProfileMapper: BaseMapper<PrivateUserObjectDTO, Profile> {
    
    override class func transform(_ dataModel: PrivateUserObjectDTO) throws -> Profile {
        var url: URL?
        if let urlString = dataModel.images?.first?.url {
            url = URL(string: urlString)
        }
        return Profile(name: dataModel.displayName,
                followers: dataModel.followers.total ?? 0,
                imageUrl: url,
                email: dataModel.email,
                product: Profile.ProductType(rawValue: dataModel.product) ?? .unknown)
    }
}
