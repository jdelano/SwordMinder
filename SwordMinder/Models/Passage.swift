//
//  Passage.swift
//  SwordMinder
//
//  Created by John Delano on 12/2/22.
//

import Foundation

/// Represents a passage of scripture, containing one or more verses. Passages cannot extend across book boundaries.
struct Passage: Identifiable, Codable {

    /// id used by Identifiable
    var id = UUID()
    
    private var updatingReference: Bool = false
    
    var version: Translation {
        didSet {
            if version != oldValue {
                versesLoaded = false
            }
        }
    }
    
    var startReference: Reference {
        didSet {
            if !updatingReference {
                updatingReference = true
                versesLoaded = false
                if startReference.book != endReference.book || startReference > endReference {
                    endReference = startReference
                }
                updatingReference = false
            }
        }
    }
    
    var endReference: Reference {
        didSet {
            if !updatingReference {
                updatingReference = true
                versesLoaded = false
                if endReference.book != startReference.book || startReference > endReference {
                    startReference = endReference
                }
                updatingReference = false
            }
        }
    }
        
    
    /// Provides a nicely formatted reference representing the passage, (e.g., John 3:16-17 or Romans 5:12-6:2)
    var referenceFormatted: String {
        var referenceString = startReference.toString()
        if endReference.chapter > startReference.chapter {
            referenceString += "-\(endReference.chapter):\(endReference.verse)"
        } else if endReference.verse > startReference.verse {
            referenceString += "-\(endReference.verse)"
        }
        return referenceString + " (\(version.rawValue))"
    }
    
    
    private var _verses: [Verse] = []
    private(set) var versesLoaded: Bool = false
    var verses: [Verse] {
        mutating get {
            if !versesLoaded {
                _verses = []
                var ref: Reference? = startReference
                while (ref != nil && ref! <= endReference) {
                    _verses.append(Verse(reference: ref!, version: version))
                    ref = ref!.next
                }
                versesLoaded = true
            }
            return _verses
        }
        set {
            _verses = newValue
        }
    }
    
    /// Retrieves a `String` containing the text for the current `Passage`
    var text: String {
        mutating get async throws {
            var text = ""
            // Prepend second and following verses with a space
            for index in verses.indices {
                text += "\(index > 0 ? " " : "")\(try await verses[index].toString())"
            }
            text += " (\(version.rawValue))"
            return text
        }
    }

    /// Initializes a new Passage struct.
    ///
    /// - Parameter verses: array of verses to include in the passage.
    init(from startReference: Reference = Reference(), to endReference: Reference? = nil, version: Translation = .esv) {
        self.version = version
        self.startReference = startReference
        if let endReference {
            self.endReference = endReference
        } else {
            self.endReference = startReference
        }
    }
    
    
    
    /// Inits a `Passage` containing all the verses starting from the beginning reference up to and including the ending reference.
    ///
    /// - Parameters:
    ///   - begin: Starting reference in string format to include in the Passage
    ///   - end: Ending reference in string format to include in the Passage. If nil, then the Passage will only contain the verse at the starting reference.
    /// - Returns: A Passage containing all the verses identified by the range of references specified. Returns nil if references cannot be found or are invalid.
    init?(fromString begin: String, toString end: String? = nil, version: Translation = .esv) {
        if let beginReference = Reference(fromString: begin) {
            if let end,
               let endReference = Reference(fromString: end) {
                self = .init(from: beginReference, to: endReference, version: version)
            } else {
                self = .init(from: beginReference, version: version)
            }
        } else {
            return nil
        }
    }

    
    /// Retrieves an `Array<String>` that contains the unformatted words of the verse for the specified passage
    ///
    /// - Parameter passage: The `Passage` for which the array of words is being retrieved
    /// - Returns: An array containing the words of the verse text for the requested reference
    var words: [String] {
        mutating get async throws {
            try await text.alphaOnly().components(separatedBy: " ")
        }
    }

    // MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case startReference
        case endReference
        case version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startReference = try container.decode(Reference.self, forKey: .startReference)
        self.endReference = try container.decode(Reference.self, forKey: .endReference)
        self.version = try container.decode(Translation.self, forKey: .version)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startReference, forKey: .startReference)
        try container.encode(endReference, forKey: .endReference)
        try container.encode(version, forKey: .version)
    }

}

