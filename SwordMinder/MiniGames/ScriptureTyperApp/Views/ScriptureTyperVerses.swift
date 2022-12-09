//
//  ScriptureTyperVerses.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/7/22.
//
//
import SwiftUI

struct ScriptureTyperVerses: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State private var editorConfig = EditorConfig()
    @State private var addPassage: Passage = Passage()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(swordMinder.passages) { passage in
                    NavigationLink {
                        FlashCardView(passage: passage)
                    } label: {
                        HStack {
                            Text(.init(passage.referenceFormatted))
                            Spacer()
                            Image(systemName: swordMinder.isPassageReviewedToday(passage) ? "checkmark" : "")
                                .foregroundColor(.green)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My Passages")
            .toolbar { toolbar }
        }
        .overlay(!swordMinder.isLoaded ? ProgressView() : nil)
        .sheet(isPresented: $editorConfig.isPresented, onDismiss: {
            if editorConfig.needsSaving {
                swordMinder.addPassage(addPassage)
            }
        }) {
            PassagePickerView(editorConfig: $editorConfig, passage: $addPassage)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        ToolbarItem {
            Button(action: addItem) {
                Image(systemName: "plus")
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            addPassage = Passage()
            editorConfig.present()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            swordMinder.removePassages(atOffsets: offsets)
        }
    }
}

struct ScriptureTyperVerses_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperVerses()
    }
}
