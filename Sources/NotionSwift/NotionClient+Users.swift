//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Users

extension NotionClient {

    public func user(
        userId: User.Identifier
    ) async throws -> User {
        try await networkClient.get(
            urlBuilder.url(path: "/v1/users/{identifier}", identifier: userId),
            headers: headers()
        )
    }

    public func usersList(
        params: BaseQueryParams
    ) async throws -> ListResponse<User> {
        try await networkClient.get(
            urlBuilder.url(path: "/v1/users", params: params.asParams),
            headers: headers()
        )
    }

    public func usersMe() async throws -> User {
        try await networkClient.get(
            urlBuilder.url(path: "/v1/users/me"),
            headers: headers()
        )
    }
}
