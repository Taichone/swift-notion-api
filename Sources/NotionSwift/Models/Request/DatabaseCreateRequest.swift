//
//  Created by Wojciech Chojnacki on 17/09/2021.
//

import Foundation

public struct DatabaseCreateRequest: Sendable {
    public let parent: DatabaseParent
    public let icon: IconFile?
    public let cover: CoverFile?
    public let title: [RichText]?
    public let properties: [Database.PropertyName: DatabasePropertyType]
    public let isInline: Bool?

    public init(
        parent: DatabaseParent,
        icon: IconFile?,
        cover: CoverFile?,
        title: [RichText]?,
        properties: [Database.PropertyName: DatabasePropertyType],
        isInline: Bool? = false
    ) {
        self.parent = parent
        self.icon = icon
        self.cover = cover
        self.title = title
        self.properties = properties
        self.isInline = isInline
    }
}

extension DatabaseCreateRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case parent
        case icon
        case cover
        case title
        case properties
        case isInline = "is_inline"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parent, forKey: .parent)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(properties, forKey: .properties)
        try container.encode(isInline, forKey: .isInline)
    }
}
