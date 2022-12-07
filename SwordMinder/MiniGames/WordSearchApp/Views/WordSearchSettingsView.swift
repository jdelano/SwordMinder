//
//  WordSearchSettingsView.swift
//  SwordMinder
//
//  Created by John Delano on 12/5/22.
//

import SwiftUI

struct WordSearchSettingsView: View {
    @Binding var difficulty: Difficulty
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Section("Difficulty") {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
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
        WordSearchSettingsView(difficulty: .constant(.hard))
    }
}
