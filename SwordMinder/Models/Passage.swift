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
    
    private var updating: Bool = false
    
    var startReference: Reference {
        didSet {
            if !updating {
                updating = true
                if startReference.book != endReference.book || startReference > endReference {
                    endReference = startReference
                }
                updating = false
            }
        }
    }
    
    var endReference: Reference {
        didSet {
            if !updating {
                updating = true
                if endReference.book != startReference.book || startReference > endReference {
                    startReference = endReference
                }
                updating = false
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
        return referenceString
    }
    
    
    /// Initializes a new Passage struct.
    ///
    /// - Note: Use the `Bible.passage` function to create a Passage.
    ///
    /// - Parameter verses: array of verses to include in the passage.
    init(from startReference: Reference = Reference(), to endReference: Reference? = nil) {
        self.startReference = startReference
        if let endReference {
            self.endReference = endReference
        } else {
            self.endReference = startReference
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case updating
        case startReference
        case endReference
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.updating = try container.decode(Bool.self, forKey: .updating)
        self.startReference = try container.decode(Reference.self, forKey: .startReference)
        self.endReference = try container.decode(Reference.self, forKey: .endReference)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(updating, forKey: .updating)
        try container.encode(startReference, forKey: .startReference)
        try container.encode(endReference, forKey: .endReference)
    }
    
}

