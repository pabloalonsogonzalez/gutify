//
//  Profile.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 3/9/24.
//

import Foundation

struct Profile {
    enum ProductType: String {
        case free = "free"
        case premium = "premium"
        case unknown
    }
    var name: String
    var followers: Int
    var imageUrl: URL?
    var email: String
    var product: ProductType
}
