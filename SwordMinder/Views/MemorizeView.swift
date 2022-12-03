//
//  MemorizeView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct MemorizeView: View {
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
                        Text(.init(passage.referenceFormatted))
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

struct MemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        let swordMinder = SwordMinder()
        return MemorizeView()
            .environmentObject(swordMinder)
    }
}
