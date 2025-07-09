//
//  Created by Wojciech Chojnacki on 23/05/2021.
//

import Foundation

// MARK: - Blocks

extension NotionClient {

    public func blockChildren(
        blockId: Block.Identifier,
        params: BaseQueryParams
    ) async throws -> ListResponse<ReadBlock> {
        try await networkClient.get(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}/children",
                identifier: blockId,
                params: params.asParams
            ),
            headers: headers()
        )
    }

    public func blockAppend(
        blockId: Block.Identifier,
        children: [WriteBlock]
    ) async throws -> ListResponse<ReadBlock> {
        try await networkClient.patch(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}/children",
                identifier: blockId
            ),
            body: BlockAppendRequest(children: children),
            headers: headers()
        )
    }

    public func blockUpdate(
        blockId: Block.Identifier,
        value: UpdateBlock
    ) async throws -> ReadBlock {
        try await networkClient.patch(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}",
                identifier: blockId
            ),
            body: value,
            headers: headers()
        )
    }

    public func blockDelete(
        blockId: Block.Identifier
    ) async throws -> ReadBlock {
        try await networkClient.delete(
            urlBuilder.url(
                path: "/v1/blocks/{identifier}",
                identifier: blockId
            ),
            headers: headers()
        )
    }
}

private struct BlockAppendRequest: Encodable {
    let children: [WriteBlock]
}
