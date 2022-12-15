//
//  JMSettings.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/14/22.
//

import SwiftUI

struct JMSettingsModel {
    
    @Binding var selectedDifficulty: String
    //@Binding var selectedInput: String
    @Binding var toggleVerse: Bool
    @Binding var toggleTimer: Bool
    
    enum JMDifficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }

//    init(selectedDifficulty: String, selectedInput: String, toggleVerse: Bool, toggleTimer: Bool) {
//        self.selectedDifficulty = selectedDifficulty
//        self.selectedInput = selectedInput
//        self.toggleVerse = toggleVerse
//        self.toggleTimer = toggleTimer
//    }
}
