//
//  DifficultyFlappy.swift
//  SwordMinder
//
//  Created by Michael Smithers on 12/14/22.
//

import Foundation

enum DifficultyFlappy : String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var rockDistance: RockDistance {
        switch self {
            case .easy: return RockDistance.spread
            case .medium : return RockDistance.medium
            case .hard : return RockDistance.close
        }
    }
}
