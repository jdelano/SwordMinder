//
//  Translation.swift
//  SwordMinder
//
//  Created by John Delano on 1/26/23.
//

import Foundation

/// Translation enumeration containing the different possible translations that this API intends to support over time
enum Translation: String, Codable, Hashable, CaseIterable, Equatable {
    case kjv = "KJV"
    case esv = "ESV"
    case nkjv = "NKJV"
    case nasb = "NASB"
    case niv = "NIV"
    case nlt = "NLT"
}
