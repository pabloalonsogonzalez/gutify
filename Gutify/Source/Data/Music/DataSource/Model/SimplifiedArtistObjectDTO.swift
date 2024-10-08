//
// SimplifiedArtistObjectDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct SimplifiedArtistObjectDTO: Codable, JSONEncodable, Hashable {

    public enum TypeDTO: String, Codable, CaseIterable {
        case artist = "artist"
    }
    /** A link to the Web API endpoint providing full details of the artist.  */
    public var href: String?
    /** The [Spotify ID](/documentation/web-api/concepts/spotify-uris-ids) for the artist.  */
    public var id: String
    /** The name of the artist.  */
    public var name: String
    /** The object type.  */
    public var type: TypeDTO?
    /** The [Spotify URI](/documentation/web-api/concepts/spotify-uris-ids) for the artist.  */
    public var uri: String?

    public init(href: String? = nil, id: String, name: String, type: TypeDTO? = nil, uri: String? = nil) {
        self.href = href
        self.id = id
        self.name = name
        self.type = type
        self.uri = uri
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case href
        case id
        case name
        case type
        case uri
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(href, forKey: .href)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(uri, forKey: .uri)
    }
}

