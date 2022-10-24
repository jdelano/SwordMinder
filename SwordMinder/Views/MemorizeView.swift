//
//  MemorizeView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct MemorizeView: View {

    @ObservedObject var swordMinder: SwordMinder

    var body: some View {
        NavigationView {
            List {
                ForEach(swordMinder.passageList()) { passage in
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
    }
    
    private func addItem() {
        withAnimation {
            swordMinder.addPassage(from: "John 3:16", to: "John 3:17")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
        }
    }
}

struct MemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        let bible = Bible(translation: .kjv)
        MemorizeView(swordMinder: SwordMinder(player: Player(passages: [
            bible.passage(from: Bible.Reference(fromString: "John 3:16"))!,
            bible.passage(from: Bible.Reference(fromString: "Genesis 1:1"))!,
            bible.passage(from: Bible.Reference(fromString: "John 1:12"))!,
            bible.passage(from: Bible.Reference(fromString: "Romans 5:8"))!,
            bible.passage(from: Bible.Reference(fromString: "Jeremiah 9:23"))!
        ])))
    }
}
