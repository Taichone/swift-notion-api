//
//  Created by Wojciech Chojnacki on 22/05/2021.
//

import Foundation

public struct Database: Sendable {
    public typealias Identifier = EntityIdentifier<Database, UUIDv4>
    public typealias PropertyName = String
    public let id: Identifier
    public let url: String
    public let title: [RichText]
    public let icon: IconFile?
    public let cover: CoverFile?
    public let createdTime: Date
    public let lastEditedTime: Date
    public let createdBy: PartialUser
    public let lastEditedBy: PartialUser
    public let properties: [PropertyName: DatabaseProperty]
    public let parent: DatabaseParent
    public let isInline: Bool

    public init(
        id: Database.Identifier,
        url: String,
        title: [RichText],
        icon: IconFile?,
        cover: CoverFile?,
        createdTime: Date,
        lastEditedTime: Date,
        createdBy: PartialUser,
        lastEditedBy: PartialUser,
        properties: [Database.PropertyName: DatabaseProperty],
        parent: DatabaseParent,
        isInline: Bool
    ) {
        self.id = id
        self.url = url
        self.title = title
        self.icon = icon
        self.cover = cover
        self.createdTime = createdTime
        self.lastEditedTime = lastEditedTime
        self.createdBy = createdBy
        self.lastEditedBy = lastEditedBy
        self.properties = properties
        self.parent = parent
        self.isInline = isInline
    }
}

extension Database: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case icon
        case cover
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
        case properties
        case parent
        case isInline = "is_inline"
    }
}

@available(iOS 13.0, *)
extension Database: Identifiable {}
