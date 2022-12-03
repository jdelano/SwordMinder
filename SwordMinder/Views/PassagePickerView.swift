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
/// View also displays the KJV text for the chosen passage at the bottom section of the form.
struct PassagePickerView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var editorConfig: EditorConfig
    @Binding var passage: Passage
    @State var passageText: String = ""
    @State var refreshing: Bool = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Starting Reference") {
                    VersePickerView(reference: $passage.startReference) { _ in
                        updatePassageText()
                    }
                }
                Section("Ending Reference") {
                    VersePickerView(reference: $passage.endReference) { _ in
                        updatePassageText()
                    }
                }
                Section("Passage") {
                    if !swordMinder.isLoaded {
                        ProgressView()
                    } else {
                        Text(.init(passage.referenceFormatted))
                        Text(.init(passageText.truncate(to: 100)))
                    }
                }
            }
            .onAppear {
                updatePassageText()
            }
            .navigationBarItems(leading: Button("Cancel") {
                editorConfig.dismiss(save: false)
            }, trailing: Button("Done") {
                editorConfig.dismiss(save: true)
            })
            .navigationTitle("Select Passage")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func updatePassageText() {
        self.passageText = swordMinder.bible.text(for: passage)
    }
}


struct PassageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PassagePickerView(editorConfig: .constant(EditorConfig()), passage: .constant(Passage(from: Reference(book: Book(named: "Psalms")!, chapter: 119, verse: 100))))
                .environmentObject(SwordMinder())
        }
    }
}
