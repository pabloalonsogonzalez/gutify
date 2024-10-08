//
// SimplifiedPlaylistObjectDTO.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct SimplifiedPlaylistObjectDTO: Codable, JSONEncodable, Hashable {

    /** `true` if the owner allows other users to modify the playlist.  */
    public var collaborative: Bool?
    /** The playlist description. _Only returned for modified, verified playlists, otherwise_ `null`.  */
    public var description: String?
    /** A link to the Web API endpoint providing full details of the playlist.  */
    public var href: String?
    /** The [Spotify ID](/documentation/web-api/concepts/spotify-uris-ids) for the playlist.  */
    public var id: String
    /** Images for the playlist. The array may be empty or contain up to three images. The images are returned by size in descending order. See [Working with Playlists](/documentation/web-api/concepts/playlists). _**Note**: If returned, the source URL for the image (`url`) is temporary and will expire in less than a day._  */
    public var images: [ImageObjectDTO]
    /** The name of the playlist.  */
    public var name: String
    /** The playlist's public/private status (if it is added to the user's profile): `true` the playlist is public, `false` the playlist is private, `null` the playlist status is not relevant. For more about public/private status, see [Working with Playlists](/documentation/web-api/concepts/playlists)  */
    public var _public: Bool?
    /** The version identifier for the current playlist. Can be supplied in other requests to target a specific playlist version  */
    public var snapshotId: String?
    /** A collection containing a link ( `href` ) to the Web API endpoint where full details of the playlist's tracks can be retrieved, along with the `total` number of tracks in the playlist. Note, a track object may be `null`. This can happen if a track is no longer available.  */
    public var tracks: PlaylistTracksRefObjectDTO
    /** The object type: \"playlist\"  */
    public var type: String?
    /** The [Spotify URI](/documentation/web-api/concepts/spotify-uris-ids) for the playlist.  */
    public var uri: String?

    public init(collaborative: Bool? = nil, description: String? = nil, href: String? = nil, id: String, images: [ImageObjectDTO], name: String, _public: Bool? = nil, snapshotId: String? = nil, tracks: PlaylistTracksRefObjectDTO, type: String? = nil, uri: String? = nil) {
        self.collaborative = collaborative
        self.description = description
        self.href = href
        self.id = id
        self.images = images
        self.name = name
        self._public = _public
        self.snapshotId = snapshotId
        self.tracks = tracks
        self.type = type
        self.uri = uri
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case collaborative
        case description
        case href
        case id
        case images
        case name
        case _public = "public"
        case snapshotId = "snapshot_id"
        case tracks
        case type
        case uri
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(collaborative, forKey: .collaborative)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(href, forKey: .href)
        try container.encode(id, forKey: .id)
        try container.encode(images, forKey: .images)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(_public, forKey: ._public)
        try container.encodeIfPresent(snapshotId, forKey: .snapshotId)
        try container.encode(tracks, forKey: .tracks)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(uri, forKey: .uri)
    }
}

