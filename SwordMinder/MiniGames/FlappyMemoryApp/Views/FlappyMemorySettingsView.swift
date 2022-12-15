//
//  FlappyMemorySettingsView.swift
//  SwordMinder
//
//  Created by Michael Smithers on 12/14/22.
//

import SwiftUI

struct FlappyMemorySettingsView: View {
    @Binding var difficultyFlappy: DifficultyFlappy
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section("Difficulty") {
                    Picker("Difficulty", selection: $difficultyFlappy) {
                        ForEach(DifficultyFlappy.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                }
            }
            .navigationTitle("Flappy Memory Settings")
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FlappyMemorySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FlappyMemorySettingsView(difficultyFlappy: .constant(.hard))
    }
}
