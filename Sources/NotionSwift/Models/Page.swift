//
//  Created by Wojciech Chojnacki on 22/05/2021.
//

import Foundation

/// The Page object contains **the property values** of a single Notion page.
public struct Page: Sendable {
    public typealias Identifier = EntityIdentifier<Page, UUIDv4>
    public typealias PropertyName = String
    public let id: Identifier
    public let createdTime: Date
    public let lastEditedTime: Date
    public let createdBy: PartialUser
    public let lastEditedBy: PartialUser
    public let icon: IconFile?
    public let cover: CoverFile?
    public let parent: PageParentType
    public let archived: Bool
    public let properties: [PropertyName: PageProperty]
    public let url: URL
    
    public init(
        id: Identifier,
        createdTime: Date,
        lastEditedTime: Date,
        createdBy: PartialUser,
        lastEditedBy: PartialUser,
        icon: IconFile?,
        cover: CoverFile?,
        parent: PageParentType,
        archived: Bool,
        properties: [PropertyName: PageProperty],
        url: URL
    ) {
        self.id = id
        self.createdTime = createdTime
        self.lastEditedTime = lastEditedTime
        self.createdBy = createdBy
        self.lastEditedBy = lastEditedBy
        self.icon = icon
        self.cover = cover
        self.parent = parent
        self.archived = archived
        self.properties = properties
        self.url = url
    }
}

extension Page: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"        
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
        case icon
        case cover
        case archived
        case parent
        case properties
        case url
    }
}

extension EntityIdentifier where Marker == Page, T == UUIDv4 {
    public var toBlockIdentifier: Block.Identifier {
        return Block.Identifier(self.rawValue)
    }
}

@available(iOS 13.0, *)
extension Page: Identifiable {}

extension Page {
    public func getTitle() -> [RichText]? {
        guard
            let titlePropertyEntry = properties.first(where: {
                if case .title = $0.value.type {
                    return true
                }

                return false
            }),
            case .title(let richText) = titlePropertyEntry.value.type
        else {
            return nil
        }

        return richText
    }
}
