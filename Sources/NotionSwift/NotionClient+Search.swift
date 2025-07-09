//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Search

extension NotionClient {
    public func search(
        request: SearchRequest
    ) async throws -> SearchResponse {
        try await networkClient.post(
            urlBuilder.url(path: "/v1/search"),
            body: request,
            headers: headers()
        )
    }
}
