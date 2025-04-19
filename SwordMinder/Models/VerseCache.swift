//
//  VerseCache.swift
//  SwordMinder
//
//  Created by John Delano on 4/17/25.
//
import Foundation

/// A protocol that defines an interface for asynchronously retrieving Bible verse text by request.
protocol VerseProvider {
    /// Retrieves the text of a verse for a given request.
    ///
    /// - Parameter request: The request identifying the verse.
    /// - Returns: The text of the verse.
    func getText(for request: VerseRequest) async throws -> String
}

actor VerseCache: VerseProvider {
    /// The shared singleton instance of `VerseCache`.
    static let shared = VerseCache()
    
    /// A cache that stores verse text keyed by `VerseRequest`.
    private var cache: [VerseRequest: String] = [:]
    
    /// The base URL used to request verse text. Defaults to the `jsonbible.com` API.
    private let baseURL: URL
    
    /// Initializes a new `VerseCache` with an optional base URL.
    ///
    /// - Parameter baseURL: The base URL to use for verse requests. Defaults to `jsonbible.com`.
    init(baseURL: URL = URL(string: "https://jsonbible.com/search/verses.php")!) {
        self.baseURL = baseURL
    }
    
    /// Retrieves the text of a Bible verse, either from the in-memory cache or by fetching it from the remote API.
    ///
    /// This method checks if the verse corresponding to the provided `VerseKey` is already present in the internal cache.
    /// If it is, the cached text is returned immediately. If not, it encodes the request as JSON,
    /// and performs an asynchronous network request to the `baseURL` to retrieve the verse text. Upon successful retrieval,
    /// the verse text is stored in the cache and returned.
    ///
    /// - Parameter request: A `VerseRequest` that uniquely identifies the verse (by reference and translation).
    /// - Returns: A `String` containing the text of the verse.
    /// - Throws:
    ///   - `VerseError.invalidURL` if the URL could not be constructed.
    ///   - `VerseError.invalidRequestEncoding` if the request JSON could not be encoded properly.
    ///   - Any `Error` thrown by `URLSession` during the network request or by `JSONDecoder` during decoding.
    ///
    /// - Important: This method is `async` and must be called from an asynchronous context. It is also `actor-isolated`,
    ///   so it provides safe concurrent access to the shared verse cache.
    ///
    /// - SeeAlso: `VerseKey`, `VerseRequest`, `VerseResponse`
    func getText(for request: VerseRequest) async throws -> String {
        if let cached = cache[request] { return cached }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        guard let json = try? JSONEncoder().encode(request),
              let jsonString = String(data: json, encoding: .utf8) else {
            throw VerseError.invalidRequestEncoding
        }
        
        components?.queryItems = [URLQueryItem(name: "json", value: jsonString)]
        
        guard let url = components?.url else {
            throw VerseError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(VerseResponse.self, from: data)
        
        cache[request] = response.text
        return response.text
    }
    
    /// Represents possible errors that can occur when retrieving Bible verse text from the remote API.
    ///
    /// These errors cover issues such as constructing a valid URL, encoding the verse request to JSON,
    /// or other problems encountered during the loading process. This enum is used internally by
    /// `VerseCache` to signal failure states that the caller should be prepared to handle.
    ///
    /// - Note: Additional errors may be thrown by underlying calls such as `URLSession` or `JSONDecoder`,
    /// but `VerseError` captures the most common failure cases specific to request construction.
    ///
    /// - SeeAlso: `VerseCache`, `VerseRequest`
    enum VerseError: Error {
        case invalidURL
        case invalidRequestEncoding
    }
}
