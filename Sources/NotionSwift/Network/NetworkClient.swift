//
//  Created by Wojciech Chojnacki on 22/05/2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum Network {
    public typealias HTTPHeaders = [String: String]

    public static let notionBaseURL = URL(string: "https://api.notion.com/")!

    public enum HTTPMethod: String {
        case GET, POST, PUT, PATCH, DELETE
    }

    public enum Errors: Error {
        case HTTPError(code: Int)
        case genericError(Error)
    }
}

public protocol NetworkClient: AnyObject, Sendable {
    func get<R: Decodable & Sendable>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async throws -> R

    func post<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async throws -> R

    func patch<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async throws -> R

    func delete<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async throws -> R

    func delete<R: Decodable & Sendable>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async throws -> R
}

public final class DefaultNetworkClient: NetworkClient, @unchecked Sendable {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let session: URLSession

    public init(sessionConfiguration: URLSessionConfiguration) {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

        session = .init(configuration: sessionConfiguration)
    }

    public func get<R: Decodable & Sendable>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async throws -> R {
        let request = buildRequest(method: .GET, url: url, headers: headers)
        return try await executeRequest(request: request)
    }

    public func post<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async throws -> R {
        var request = buildRequest(method: .POST, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            throw NotionClientError.bodyEncodingError(error)
        }
        Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request: request)
    }

    public func patch<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async throws -> R {
        var request = buildRequest(method: .PATCH, url: url, headers: headers)
        let requestBody: Data

        do {
            requestBody = try encoder.encode(body)
        } catch {
            throw NotionClientError.bodyEncodingError(error)
        }

        Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request: request)
    }

    public func delete<R: Decodable & Sendable>(
        _ url: URL,
        headers: Network.HTTPHeaders
    ) async throws -> R {
        return try await genericDelete(url, body: Optional<Int>.none, headers: headers)
    }

    public func delete<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders
    ) async throws -> R {
        return try await genericDelete(url, body: body, headers: headers)
    }

    private func genericDelete<T: Encodable & Sendable, R: Decodable & Sendable>(
        _ url: URL,
        body: T?,
        headers: Network.HTTPHeaders
    ) async throws -> R {
        var request = buildRequest(method: .DELETE, url: url, headers: headers)
        if let body = body {
            let requestBody: Data

            do {
                requestBody = try encoder.encode(body)
            } catch {
                throw NotionClientError.bodyEncodingError(error)
            }

            Environment.log.trace("BODY:\n " + String(data: requestBody, encoding: .utf8)!)

            request.httpBody = requestBody
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await executeRequest(request: request)
    }

    private func buildRequest(
        method: Network.HTTPMethod,
        url: URL,
        headers: Network.HTTPHeaders
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        for item in headers {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }

        return request
    }

    private func executeRequest<T: Decodable & Sendable>(
        request: URLRequest
    ) async throws -> T {
        Environment.log.debug("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let error = NetworkClientHelpers.extractError(data: data, response: response, error: nil) {
                throw error
            }
            
            Environment.log.trace(String(data: data, encoding: .utf8) ?? "")
            
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch let decodingError as Swift.DecodingError {
                throw NotionClientError.decodingError(decodingError)
            } catch {
                throw NotionClientError.genericError(error)
            }
        } catch let error as NotionClientError {
            throw error
        } catch {
            throw NotionClientError.genericError(error)
        }
    }
}
