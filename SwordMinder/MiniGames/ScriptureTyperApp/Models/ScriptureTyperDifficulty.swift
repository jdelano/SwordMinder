//
//  ScriptureTyperModel.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/9/22.
//

import Foundation
enum ScriptureTyperDifficulty {
    case easy
    case medium
    case hard
    
    var Time: Int {
        switch self {
            case .easy: return 120
            case .medium : return 60
            case .hard : return 30
        }
    }
}
