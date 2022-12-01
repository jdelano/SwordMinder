//
//  MemorizeView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct MemorizeView: View {

    @EnvironmentObject var swordMinder: SwordMinder

    var body: some View {
        NavigationStack {
            List {
                ForEach(swordMinder.passages) { passage in
                    NavigationLink {
                        FlashCardView(passage: passage)
                    } label: {
                        Text(.init(passage.reference ))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My Passages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .overlay(!swordMinder.isLoaded ? ProgressView() : nil)
    }
    
    private func addItem() {
        withAnimation {
            swordMinder.addPassage(from: "John 3:16", to: "John 3:17")
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
