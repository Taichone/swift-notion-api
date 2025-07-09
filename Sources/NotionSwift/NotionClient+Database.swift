//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Database

extension NotionClient {
    
    public func database(
        databaseId: Database.Identifier
    ) async throws -> Database {
        try await networkClient.get(
            urlBuilder.url(path: "/v1/databases/{identifier}", identifier: databaseId),
            headers: headers()
        )
    }

    public func databaseQuery(
        databaseId: Database.Identifier,
        params: DatabaseQueryParams
    ) async throws -> ListResponse<Page> {
        try await networkClient.post(
            urlBuilder.url(path: "/v1/databases/{identifier}/query", identifier: databaseId),
            body: params,
            headers: headers()
        )
    }

    public func databaseCreate(
        request: DatabaseCreateRequest
    ) async throws -> Database {
        try await networkClient.post(
            urlBuilder.url(path: "/v1/databases"),
            body: request,
            headers: headers()
        )
    }

    public func databaseUpdate(
        databaseId: Database.Identifier,
        request: DatabaseUpdateRequest
    ) async throws -> Database {
        try await networkClient.patch(
            urlBuilder.url(path: "/v1/databases/{identifier}", identifier: databaseId),
            body: request,
            headers: headers()
        )
    }
}
