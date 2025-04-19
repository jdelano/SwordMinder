//
//  Passage.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Represents a passage of Scripture, consisting of one or more contiguous verses within a single book of the Bible.
/// Passages cannot extend across book boundaries and must follow canonical order.
struct Passage: Identifiable, Codable {
    
    /// The unique ID for the passage (random UUID)
    var id = UUID()
    
    /// The Bible translation version used for the passage
    var translation: Translation
    
    /// The first verse in the passage
    private(set) var startReference: Reference
    
    /// The last verse in the passage
    private(set) var endReference: Reference
    
    /// The list of verses that make up this passage, from `startReference` to `endReference` (inclusive).
    var verses: [Verse] {
        var results: [Verse] = []
        var ref: Reference? = startReference
        
        while let current = ref, current <= endReference {
            results.append(Verse(reference: current, translation: translation))
            ref = current.next
        }
        
        return results
    }
    
    /// Provides a nicely formatted reference representing the passage, (e.g., John 3:16-17 or Romans 5:12-6:2)
    var referenceFormatted: String {
        var referenceString = startReference.toString()
        if endReference.chapter > startReference.chapter {
            referenceString += "-\(endReference.chapter):\(endReference.verse)"
        } else if endReference.verse > startReference.verse {
            referenceString += "-\(endReference.verse)"
        }
        return referenceString + " (\(translation.rawValue))"
    }
    
    /// Initializes a new Passage struct.
    ///
    /// - Parameter verses: array of verses to include in the passage.
    init(from startReference: Reference = Reference(),
         to endReference: Reference? = nil,
         translation: Translation = .esv
    ) {
        self.startReference = startReference
        self.endReference = endReference ?? startReference
        self.translation = translation
        
        // Clamp if needed (e.g., book mismatch or reversed)
        if self.startReference.book != self.endReference.book ||
            self.startReference > self.endReference {
            self.endReference = self.startReference
        }
    }
    
    /// Inits a `Passage` containing all the verses starting from the beginning reference up to and including the ending reference.
    ///
    /// - Parameters:
    ///   - begin: Starting reference in string format to include in the Passage
    ///   - end: Ending reference in string format to include in the Passage. If nil, then the Passage will only contain the verse at the starting reference.
    /// - Returns: A Passage containing all the verses identified by the range of references specified. Returns nil if references cannot be found or are not parseable.
    init?(fromString begin: String, toString end: String? = nil, version: Translation = .esv) {
        guard let beginReference = Reference(fromString: begin) else { return nil }
        if let end, let endReference = Reference(fromString: end) {
            self.init(from: beginReference, to: endReference, translation: version)
        } else {
            self.init(from: beginReference, translation: version)
        }
    }
    
    
    /// Assembles the full passage text by fetching each verse and joining them in order.
    ///
    /// - Returns: The combined passage text, prefixed with verse numbers and suffixed with version.
    func text() async throws -> String {
        // Prepend second and following verses with a space
        let rendered = try await verses.asyncMap { try await $0.formattedText() }
        return rendered.joined(separator: " ") + " (\(translation.rawValue))"
    }
    
    
    /// Returns an array of unformatted, alphabetic words contained in the passage text.
    func words() async throws -> [String] {
        try await text().alphaOnly().components(separatedBy: " ")
    }
    
    /// Updates the passage boundaries safely, ensuring the passage stays valid within the same book.
    /// This method should be called whenever the start, end, or translation is changed by the user.
    ///
    /// - Parameters:
    ///   - start: The updated start reference (or `nil` to keep existing)
    ///   - end: The updated end reference (or `nil` to keep existing)
    ///   - translation: The updated translation (or `nil` to keep existing)
    mutating func updateReferences(start: Reference? = nil,
                                   end: Reference? = nil,
                                   translation: Translation? = nil) {
        
        let newVersion = translation ?? self.translation
        let newStart = start ?? self.startReference
        let newEnd = end ?? self.endReference
        
        // If the books don’t match, collapse to the earlier reference
        if newStart.book != newEnd.book {
            self.translation = newVersion
            
            // Collapse to the reference that was explicitly changed
            if start != nil {
                self.startReference = newStart
                self.endReference = newStart
            } else {
                self.startReference = newEnd
                self.endReference = newEnd
            }
            return
        }
        
        self.translation = newVersion
        if newStart <= newEnd {
            self.startReference = newStart
            self.endReference = newEnd
        } else {
            self.startReference = newEnd
            self.endReference = newStart
        }
    }
    
    // MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case startReference
        case endReference
        case translation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startReference = try container.decode(Reference.self, forKey: .startReference)
        self.endReference = try container.decode(Reference.self, forKey: .endReference)
        self.translation = try container.decode(Translation.self, forKey: .translation)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startReference, forKey: .startReference)
        try container.encode(endReference, forKey: .endReference)
        try container.encode(translation, forKey: .translation)
    }
    
}

