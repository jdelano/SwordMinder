//
//  PassagePicker.swift
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
struct PassagePicker: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var startReference: Bible.Reference
    @Binding var endReference: Bible.Reference
    @State var passage: String = ""
    @State var refreshing: Bool = true
    
    var body: some View {
        Form {
            Section("Starting Reference") {
                VersePicker(reference: $startReference) { reference in
                    withAnimation {
                        endReference = startReference
                    }
                } chapterChanged: { chapter in
                    if endReference.chapter < chapter {
                        withAnimation {
                            endReference.chapter = chapter
                        }
                    }
                } verseChanged: { verse in
                    if endReference.chapter == startReference.chapter && endReference.verse < verse {
                        withAnimation {
                            endReference.verse = verse
                        }
                    }
                }
                .onChange(of: startReference) { _ in refreshPassage() }
            }
            Section("Ending Reference") {
                VersePicker(reference: $endReference) { reference in
                    withAnimation {
                        startReference = endReference
                    }
                } chapterChanged: { chapter in
                    if startReference.chapter > chapter {
                        withAnimation {
                            startReference.chapter = chapter
                        }
                    }
                } verseChanged: { verse in
                    if startReference.chapter == endReference.chapter && startReference.verse > verse {
                        withAnimation {
                            startReference.verse = verse
                        }
                    }
                }
                .onChange(of: endReference) { _ in refreshPassage() }
            }
            Section("Passage") {
                if !swordMinder.isLoaded {
                    ProgressView()
                } else {
                    Text(.init(passage))
                }
            }
        }
        .navigationTitle("Select Passage")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: swordMinder.isLoaded) { loaded in
            if loaded {
                refreshPassage()
            }
        }
        .onAppear {
            refreshPassage()
        }
    }
    
    private func refreshPassage() {
        withAnimation {
            passage = swordMinder.bible.passage(from: startReference, to: endReference)?.reference ?? ""
        }
    }
}

struct PassageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PassagePicker(startReference: .constant(Bible.reference()), endReference: .constant(Bible.reference()))
                .environmentObject(SwordMinder())
        }
    }
}
