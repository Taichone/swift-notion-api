//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Pages

extension NotionClient {
    
    public func page(
        pageId: Page.Identifier
    ) async throws -> Page {
        try await networkClient.get(
            urlBuilder.url(path: "/v1/pages/{identifier}", identifier: pageId),
            headers: headers()
        )
    }

    public func pageCreate(
        request: PageCreateRequest
    ) async throws -> Page {
        try await networkClient.post(
            urlBuilder.url(path: "/v1/pages"),
            body: request,
            headers: headers()
        )
    }

    public func pageUpdate(
        pageId: Page.Identifier,
        request: PageUpdateRequest
    ) async throws -> Page {
        try await networkClient.patch(
            urlBuilder.url(path: "/v1/pages/{identifier}", identifier: pageId),
            body: request,
            headers: headers()
        )
    }
}
