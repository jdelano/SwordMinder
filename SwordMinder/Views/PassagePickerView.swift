//
//  PassagePickerView.swift
//  SwordMinder
//
//  Created by John Delano on 12/1/22.
//

import SwiftUI

/// View to display a Form within a NavigationView that allows the user to select a passage of scripture containing a start reference and an end reference.
/// This view will only allow the passage to span within a single book.
/// It also prevents the selection of an ending reference to occur before a starting reference; if that is attempted, the ending reference is made equal to the starting reference.
/// When an ending reference is changed to occur before the starting reference, the view will adjust the starting reference to equal the ending reference.
/// View also displays the selected Bible version's text for the chosen passage at the bottom section of the form.
struct PassagePickerView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var editorConfig: EditorConfig
    @Binding var passage: Passage
    
    var body: some View {
        NavigationStack {
            Form {
                translationSection
                
                Section("Starting Reference") {
                    VersePickerView(reference: passage.startReference) { ref in
                        passage.updateReferences(start: ref)
                        swordMinder.loadPassageText(for: passage)
                    }
                    
                }
                
                Section("Ending Reference") {
                    VersePickerView(reference: passage.endReference) { ref in
                        passage.updateReferences(end: ref)
                        swordMinder.loadPassageText(for: passage)
                    }
                }
                
                Section("Passage") {
                    Group {
                        Text(.init(passage.referenceFormatted))
                        
                        passageContent
                    }
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    editorConfig.dismiss(save: false)
                },
                trailing: Button("Done") {
                    editorConfig.dismiss(save: true)
                }
            )
            .navigationTitle("Select Passage")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            swordMinder.loadPassageText(for: passage)
        }
    }
    
    @ViewBuilder
    private var translationSection: some View {
        Section("Translation") {
            Picker("Version", selection: $passage.translation) {
                ForEach(Translation.allCases, id: \.self) { value in
                    Text(value.rawValue)
                        .tag(value)
                }
            }
            .accessibilityLabel("Bible translation version")
            .onChange(of: passage.translation) { _, translation in
                passage.updateReferences(translation: translation)
                swordMinder.loadPassageText(for: passage)
            }
            .pickerStyle(.menu)
        }
    }
  
    @ViewBuilder
    private var passageContent: some View {
        VStack(spacing: 16) {
            if swordMinder.isLoadingPassage {
                ProgressView()
                    .transition(.opacity)
            } else if let error = swordMinder.passageLoadError {
                Text("⚠️ Error loading passage: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .transition(.opacity)
            } else {
                Text(.init(swordMinder.currentPassageText))
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: swordMinder.isLoadingPassage || swordMinder.passageLoadError != nil)
    }
}


#Preview {
    @Previewable @State var passage = Passage(from: Reference(book: .psalms, chapter: 119, verse: 100))
    NavigationView {
        PassagePickerView(editorConfig: .constant(EditorConfig()), passage: $passage)
            .environmentObject(SwordMinder())
    }
}

