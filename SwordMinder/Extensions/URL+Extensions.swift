//
//  URL+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 11/22/22.
//

import Foundation

extension URL {
//    /// Retrieves a URL for specified resource name for a json file stored in the project
//    static func localUrl(for resource: String) -> URL? {
//        Bundle.main.url(forResource: resource, withExtension: "json")
//    }
    
    static func decode<DecodingType: Decodable>(_ resource: String) async -> DecodingType? {
        do {
            if let fileLocation = Bundle.main.url(forResource: resource, withExtension: "json") {
                let data = try await Data(contentsOfUrl: fileLocation)
                return try JSONDecoder().decode(DecodingType.self, from: data)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        return nil
    }
}

extension Data {
    init(contentsOfUrl: URL) async throws {
        self = try .init(contentsOf: contentsOfUrl)
    }
}



