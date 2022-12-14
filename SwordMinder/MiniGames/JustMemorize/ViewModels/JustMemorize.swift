//
//  JustMemorize.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/11/22.
//

import SwiftUI

class JustMemorize: ObservableObject {
    
    
    ///This func accepts a string and returns a double of the relevant difficulty multiplier.
    func difficultyMultiplier(difficulty: String) -> Double {
        switch difficulty {
            case "Easy":
                return 0.15
            case "Medium":
                return 0.5
            case "Hard":
                return 1
            default:
                return 0.15
        }
    }
    
}
