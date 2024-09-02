//
// PagingArtistObjectDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct PagingArtistObjectDTO: Codable, JSONEncodable, Hashable {

    /** A link to the Web API endpoint returning the full result of the request  */
    public var href: String
    /** The maximum number of items in the response (as set in the query or by default).  */
    public var limit: Int
    /** URL to the next page of items. ( `null` if none)  */
    public var next: String?
    /** The offset of the items returned (as set in the query or by default)  */
    public var offset: Int
    /** URL to the previous page of items. ( `null` if none)  */
    public var previous: String?
    /** The total number of items available to return.  */
    public var total: Int
    public var items: [ArtistObjectDTO]

    public init(href: String, limit: Int, next: String?, offset: Int, previous: String?, total: Int, items: [ArtistObjectDTO]) {
        self.href = href
        self.limit = limit
        self.next = next
        self.offset = offset
        self.previous = previous
        self.total = total
        self.items = items
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case href
        case limit
        case next
        case offset
        case previous
        case total
        case items
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(href, forKey: .href)
        try container.encode(limit, forKey: .limit)
        try container.encode(next, forKey: .next)
        try container.encode(offset, forKey: .offset)
        try container.encode(previous, forKey: .previous)
        try container.encode(total, forKey: .total)
        try container.encode(items, forKey: .items)
    }
}

