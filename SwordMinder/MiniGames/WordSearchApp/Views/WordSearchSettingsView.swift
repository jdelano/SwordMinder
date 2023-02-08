//
//  WordSearchSettingsView.swift
//  SwordMinder
//
//  Created by John Delano on 12/5/22.
//

import SwiftUI

struct WordSearchSettingsView: View {
    @Binding var settings: WordSearch

    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section("Difficulty") {
                    Picker("Difficulty", selection: $settings.difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                }
                Section("Tutorial") {
                    Toggle(isOn: $settings.showTutorial) {
                        Text("Show Tutorial?")
                    }
                }
            }
            .navigationTitle("Word Search Settings")
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

struct WordSearchSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchSettingsView(settings: .constant(WordSearch()))
    }
}
