//
//  Settings.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

// later this struct will serve for ALL of the settings. I'd like to keep all of them in one navigation stack if I can.
struct Settings: View {
    @State private var toggleTest: Bool = false
    
    //Will likely be an enum or something.
    private var difficulties = ["Easy", "Medium", "Hard"]
    @State private var selectedDifficulty = "Easy"
    
    private var inputTypes = ["Dictation", "Typing"]
    @State private var selectedInput = "Typing"
    
    // Consider a scroll view if necessary.
    var body: some View {
        VStack {
            VStack{
                Text("(Just Memorize Logo)")
                    .padding()
                    .border(.black)
                // Difficulty Selection
                Text("Difficulty")
                Picker ("Difficulty Picker", selection: $selectedDifficulty) {
                    ForEach(difficulties, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                //Input Type
                Text("Input Type:")
                Picker ("Input Picker", selection: $selectedInput) {
                    ForEach(inputTypes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
                // Input Selection
                /*HStack {
                    Text("Input Type:")
                    Picker ("Input Picker", selection: $selectedInput) {
                        ForEach(inputTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }*/
            
            // Show verse?
            HStack {
                Toggle(isOn: $toggleTest) {
                    Text("Show Verse First")
                    // Text modifiers may go here
                }
                .tint(.blue)
                .padding()
            }
        }
    }
}//Settings Struct

// It may be easier to not have this but I keep getting errors in button. It also serves as a good placeholder for later.
private func nothing() {
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
