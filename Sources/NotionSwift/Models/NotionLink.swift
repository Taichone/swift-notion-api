//
//  File.swift
//  
//
//  Created by Wojciech Chojnacki on 31/05/2021.
//

import Foundation

public struct NotionLink: Sendable {
    public let url: String?

    public init(url: String? = nil) {
        self.url = url
    }
}

extension NotionLink: Codable {}
