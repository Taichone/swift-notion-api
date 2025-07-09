![](banner.png)
# NotionSwift

Unofficial [Notion](https://www.notion.so) SDK for iOS & macOS. 

**Swift 6 Ready** - Full support for strict concurrency checking and async/await patterns.

## API Documentation

This library is a client for the official Notion API. 
For more details and documentation please check [Notion Developer Portal](https://developers.notion.com/)

## Requirements

- **Swift 6.0+**
- **iOS 18.0+** / **macOS 15.0+**
- Xcode 16.0+

## Installation

### Swift Package Manager (Recommended)

```swift
dependencies: [
    .package(url: "https://github.com/chojnac/NotionSwift.git", from: "0.9.0")
]
```

### CocoaPods

```ruby
pod 'NotionSwift', '~> 0.9.0'
```

## Usage

All API methods now use **async/await** patterns for better concurrency support and cleaner code.

Currently, this library supports only the "internal integration" authorization mode. For more information about authorization and 
instruction how to obtain `NOTION_TOKEN` please check [Notion Official Documentation](https://developers.notion.com/docs/authorization).

**Important:** Integrations are granted access to resources (pages and databases) which users have shared with the integration. Resources that are not shared with the integration are not visible by API endpoints. 

### Creating a Notion client

```swift
let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: "{NOTION_TOKEN}"))
```

### Tweak network configuration

To tweak things like network timeouts you can provide a custom `URLSessionConfiguration` to `NotionClient` like below.

```swift
let sessionConfig = URLSessionConfiguration.default
sessionConfig.timeoutIntervalForRequest = 15
let notion = NotionClient(
    accessKeyProvider: StringAccessKeyProvider(accessKey: "{NOTION_TOKEN}"), 
    sessionConfiguration: sessionConfig
)
```

If that's not enough for your needs, you can implement the `NetworkClient` protocol and provide your implementation to `NotionClient`.

### List all databases

The `https://api.notion.com/v1/databases` is deprecated. The recommended way to list all databases is to use `https://api.notion.com/v1/search` endpoint. 
In theory, search allows filtering results by object type. However, currently, the only filter allowed is `object` which will filter by type of object (either `page` or `database`)
To narrow search results, use code snippet below. 

```swift
// fetch available databases
do {
    let searchResult = try await notion.search(request: .init(filter: .database))
    let databases = searchResult.results.compactMap { object -> Database? in
        if case .database(let db) = object {
            return db
        }
        return nil
    }
    print(databases)
} catch {
    print("Error fetching databases: \(error)")
}
```

### Query a database

In this example we will get all pages in the database. To narrow results use `params` argument.

```swift
let databaseId = Database.Identifier("{DATABASE UUIDv4}")

do {
    let result = try await notion.databaseQuery(databaseId: databaseId)
    print(result)
} catch {
    print("Error querying database: \(error)")
}
```

### Retrieve a database

```swift
let databaseId = Database.Identifier("{DATABASE UUIDv4}")

do {
    let database = try await notion.database(databaseId: databaseId)
    print(database)
} catch {
    print("Error retrieving database: \(error)")
}
```

### Create a database

```swift
let parentPageId = Page.Identifier("e67db074-973a-4ddb-b397-66d3c75f9ec9")

let request = DatabaseCreateRequest(
    parent: .pageId(parentPageId),
    icon: .emoji("🤔"),
    cover: .external(url: "https://images.unsplash.com/photo-1606787366850-de6330128bfc"),
    title: [
        .init(string: "Created at: \(Date())")
    ],
    properties: [
        "Field 10": .richText
    ]
)

do {
    let database = try await notion.databaseCreate(request: request)
    print(database)
} catch {
    print("Error creating database: \(error)")
}
```

### Update a database

```swift
let id = Database.Identifier("{DATABASE UUIDv4}")

// update cover, icon & add a new field
let request = DatabaseUpdateRequest(
    title: nil,
    icon: .emoji("🤔"),
    cover: .external(url: "https://images.unsplash.com/photo-1606787366850-de6330128bfc"),
    properties: [
        "Field 10": .richText
    ]
)

do {
    let database = try await notion.databaseUpdate(databaseId: id, request: request)
    print(database)
} catch {
    print("Error updating database: \(error)")
}
```

### Create a database entry

Notion database entries are pages, whose properties conform to the parent database's schema.

```swift
let databaseId = Database.Identifier("{DATABASE UUIDv4}")

let request = PageCreateRequest(
    parent: .database(databaseId),
    properties: [
        "title": .init(
            type: .title([
                .init(string: "Lorem ipsum \(Date())")
            ])
        ),
        "Field 10": .init(
            type: .richText([
                .init(string: "dolor sit amet")
            ])
        )
    ]
)

do {
    let page = try await notion.pageCreate(request: request)
    print(page)
} catch {
    print("Error creating page: \(error)")
}
```

### Retrieve a page

Retrieve page properties. 

```swift
let pageId = Page.Identifier("{PAGE UUIDv4}")

do {
    let page = try await notion.page(pageId: pageId)
    print(page)
} catch {
    print("Error retrieving page: \(error)")
}
```

Page content (text for example) is represented as an array of blocks. The example below loads properties and page content. 

```swift
let pageId = Page.Identifier("{PAGE UUIDv4}")

do {
    print("---- Properties -----")
    let page = try await notion.page(pageId: pageId)
    print(page)
    
    print("---- Children -----")
    let children = try await notion.blockChildren(blockId: page.id.toBlockIdentifier)
    print(children)
} catch {
    print("Error: \(error)")
}
```

**Note:** The API returns only the direct children of the page. If there is content nested in the block (nested lists for example) it requires other calls. 

### Create a page

```swift
let parentPageId = Page.Identifier("{PAGE UUIDv4}")

let request = PageCreateRequest(
    parent: .page(parentPageId),
    properties: [
        "title": .init(
            type: .title([
                .init(string: "Lorem ipsum \(Date())")
            ])
        )
    ]
)

do {
    let page = try await notion.pageCreate(request: request)
    print(page)
} catch {
    print("Error creating page: \(error)")
}
```

### Update page properties

```swift
let pageId = Page.Identifier("{PAGE UUIDv4}")

// update title property
let request = PageUpdateRequest(
    properties: [
        .name("title"): .init(
            type: .title([
                .init(string: "Updated at: \(Date())")
            ])
        )
    ]
)

do {
    let page = try await notion.pageUpdate(pageId: pageId, request: request)
    print(page)
} catch {
    print("Error updating page: \(error)")
}
```

### Delete page 

```swift
let pageId = Page.Identifier("{PAGE UUIDv4}")

// Archive page (trash a page)
let request = PageUpdateRequest(archived: true)

do {
    let page = try await notion.pageUpdate(pageId: pageId, request: request)
    print(page)
} catch {
    print("Error deleting page: \(error)")
}
```

### Retrieve block children

Note: This endpoint returns only the first level of children, so for example, nested list items won't be returned. In that case, you need to make another request with the block id of the parent block.

```swift
let pageId = Block.Identifier("{PAGE UUIDv4}")

do {
    let children = try await notion.blockChildren(blockId: pageId)
    print(children)
} catch {
    print("Error retrieving block children: \(error)")
}
```

### Append block children

```swift
let pageId = Block.Identifier("{PAGE UUIDv4}")

// append paragraph with styled text to a page.
let blocks: [WriteBlock] = [
    .heading1(["Heading 1"], color: .orange),
    .paragraph([
        "Lorem ipsum dolor sit amet, ",
        .init(string: "consectetur", annotations: .bold),
        " adipiscing elit."
    ]),
    .heading2(["Heading 2"], color: .orangeBackground),
    .columnList(columns: [
        .column([
            .paragraph(["Column 1"])
        ]),
        .column([
            .paragraph(["Column 2"])
        ])
    ]),
    try! .table(
        width: 2,
        headers: [
            ["Header 1"], ["Header 2"]
        ],
        rows: [
            .row(
                header: ["Row 1 header"],
                cells: [
                    ["Cell 1-1"], ["Cell 1-2"]
                ]
            ),
            .row(
                cells: [
                    ["Cell 2-1"], ["Cell 2-2"]
                ]
            )
        ]
    )
]

do {
    let result = try await notion.blockAppend(blockId: pageId, children: blocks)
    print(result)
} catch {
    print("Error appending blocks: \(error)")
}
```

### Update a block

```swift
let blockId = Block.Identifier("{BLOCK UUIDv4}")
let text: [RichText] = [
    "Current time: ",
    .init(string: Date().description, annotations: .bold)
]
let block = UpdateBlock(type: .paragraph(text: text))

do {
    let updatedBlock = try await notion.blockUpdate(blockId: blockId, value: block)
    print("Updated: \(updatedBlock)")
} catch {
    print("Error updating block: \(error)")
}
```

### Block delete

```swift
let blockId = Block.Identifier("{BLOCK UUIDv4}")

do {
    let deletedBlock = try await notion.blockDelete(blockId: blockId)
    print("Deleted: \(deletedBlock)")
} catch {
    print("Error deleting block: \(error)")
}
```

### Retrieve a user

```swift
let id = User.Identifier("{USER UUIDv4}")

do {
    let user = try await notion.user(userId: id)
    print(user)
} catch {
    print("Error retrieving user: \(error)")
}
```

### List all users

```swift
do {
    let users = try await notion.usersList()
    print(users)
} catch {
    print("Error listing users: \(error)")
}
```

### Search

Search for pages & databases with a title containing text "Lorem"

```swift
do {
    let searchResult = try await notion.search(
        request: .init(
            query: "Lorem"
        )
    )
    print(searchResult)
} catch {
    print("Error searching: \(error)")
}
```

Search for all databases and ignore pages.

```swift
do {
    let searchResult = try await notion.search(
        request: .init(
            filter: .database
        )
    )
    print(searchResult)
} catch {
    print("Error searching databases: \(error)")
}
```

Get all pages & databases

```swift
do {
    let searchResult = try await notion.search()
    print(searchResult)
} catch {
    print("Error searching: \(error)")
}
```

### Error Handling

With async/await, error handling is more straightforward using do-catch blocks:

```swift
do {
    let page = try await notion.page(pageId: pageId)
    // Success - use page
} catch NotionClientError.httpError(let statusCode) {
    print("HTTP Error: \(statusCode)")
} catch NotionClientError.decodingError(let decodingError) {
    print("Decoding Error: \(decodingError)")
} catch {
    print("Other Error: \(error)")
}
```

### Using with async/await in SwiftUI

```swift
struct ContentView: View {
    @State private var pages: [Page] = []
    
    var body: some View {
        List(pages, id: \.id) { page in
            Text(page.properties["title"]?.title?.first?.plainText ?? "No title")
        }
        .task {
            await loadPages()
        }
    }
    
    private func loadPages() async {
        let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: "{NOTION_TOKEN}"))
        let databaseId = Database.Identifier("{DATABASE UUIDv4}")
        
        do {
            let result = try await notion.databaseQuery(databaseId: databaseId)
            pages = result.results
        } catch {
            print("Error loading pages: \(error)")
        }
    }
}
```

### Logging and debugging

`NotionSwift` provides an internal rudimentary logging system to track HTTP traffic. 
To enable it you need to set a built-in or custom logger handler and decide about log level (`.info` by default).
With `.trace` log level you can see all content of a request. This is useful to track mapping issues between library data models and API.

Example logging configuration:

```swift
// This code should be in the ApplicationDelegate

NotionSwiftEnvironment.logHandler = NotionSwift.PrintLogHandler() // uses print command
NotionSwiftEnvironment.logLevel = .trace // show me everything
```

## Migration from Callback-based API

If you're migrating from the previous callback-based version:

**Old (Callback-based):**
```swift
notion.page(pageId: pageId) { result in
    switch result {
    case .success(let page):
        print(page)
    case .failure(let error):
        print(error)
    }
}
```

**New (async/await):**
```swift
do {
    let page = try await notion.page(pageId: pageId)
    print(page)
} catch {
    print(error)
}
```

## Swift 6 Concurrency Features

This library now fully supports Swift 6's strict concurrency checking:

- All public types conform to `Sendable` where appropriate
- Network operations use structured concurrency
- Thread-safe access to shared resources
- No data races or concurrency warnings

## License

**NotionSwift** is available under the MIT license. See the [LICENSE](https://github.com/chojnac/NotionSwift/blob/master/LICENSE) file for more info.
