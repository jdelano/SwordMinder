//
//  Difficulty.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import Foundation

enum Difficulty : String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var placementTypes: [PlacementType] {
        switch self {
            case .easy: return [.leftRight, .upDown].shuffled()
            case .medium : return [.leftRight, .rightLeft, .upDown, .downUp].shuffled()
            case .hard : return PlacementType.allCases.shuffled()
        }
    }
}
