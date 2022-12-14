//
//  JMSettings.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/14/22.
//

import SwiftUI

class JMSettings {
    
    @Published var selectedDifficulty: String
    @Published var selectedInput: String
    @Published var toggleVerse: Bool
    @Published var toggleTimer: Bool
    
    enum JMDifficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    
    
    init(selectedDifficulty: String, selectedInput: String, toggleVerse: Bool, toggleTimer: Bool) {
        self.selectedDifficulty = selectedDifficulty
        self.selectedInput = selectedInput
        self.toggleVerse = toggleVerse
        self.toggleTimer = toggleTimer
    }
    
}
