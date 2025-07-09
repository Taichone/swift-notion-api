//
//  Created by Wojciech Chojnacki on 06/06/2021.
//

import Foundation

public protocol NotionClientType: AnyObject, Sendable {

    // MARK: - block

    func blockChildren(
        blockId: Block.Identifier,
        params: BaseQueryParams
    ) async throws -> ListResponse<ReadBlock>

    func blockAppend(
        blockId: Block.Identifier,
        children: [WriteBlock]
    ) async throws -> ListResponse<ReadBlock>

    func blockUpdate(
        blockId: Block.Identifier,
        value: UpdateBlock
    ) async throws -> ReadBlock

    func blockDelete(
        blockId: Block.Identifier
    ) async throws -> ReadBlock

    // MARK: - database

    func database(
        databaseId: Database.Identifier
    ) async throws -> Database
    
    func databaseQuery(
        databaseId: Database.Identifier,
        params: DatabaseQueryParams
    ) async throws -> ListResponse<Page>

    func databaseCreate(
        request: DatabaseCreateRequest
    ) async throws -> Database

    func databaseUpdate(
        databaseId: Database.Identifier,
        request: DatabaseUpdateRequest
    ) async throws -> Database

    // MARK: - page

    func page(
        pageId: Page.Identifier
    ) async throws -> Page

    func pageCreate(
        request: PageCreateRequest
    ) async throws -> Page

    func pageUpdate(
        pageId: Page.Identifier,
        request: PageUpdateRequest
    ) async throws -> Page

    // MARK: - user

    func user(
        userId: User.Identifier
    ) async throws -> User

    func usersList(
        params: BaseQueryParams
    ) async throws -> ListResponse<User>

    func usersMe() async throws -> User

    // MARK: - search
    
    func search(
        request: SearchRequest
    ) async throws -> SearchResponse
}

// MARK: - default arguments

extension NotionClientType {

    public func blockChildren(
        blockId: Block.Identifier
    ) async throws -> ListResponse<ReadBlock> {
        try await blockChildren(blockId: blockId, params: .init())
    }

    public func databaseQuery(
        databaseId: Database.Identifier
    ) async throws -> ListResponse<Page> {
        try await databaseQuery(databaseId: databaseId, params: .init())
    }

    public func usersList() async throws -> ListResponse<User> {
        try await usersList(params: .init())
    }

    public func search() async throws -> SearchResponse {
        try await search(request: .init())
    }
}
