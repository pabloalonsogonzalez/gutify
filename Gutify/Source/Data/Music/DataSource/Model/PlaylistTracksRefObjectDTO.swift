//
// PlaylistTracksRefObjectDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct PlaylistTracksRefObjectDTO: Codable, JSONEncodable, Hashable {

    /** A link to the Web API endpoint where full details of the playlist's tracks can be retrieved.  */
    public var href: String?
    /** Number of tracks in the playlist.  */
    public var total: Int

    public init(href: String? = nil, total: Int) {
        self.href = href
        self.total = total
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case href
        case total
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(href, forKey: .href)
        try container.encode(total, forKey: .total)
    }
}

