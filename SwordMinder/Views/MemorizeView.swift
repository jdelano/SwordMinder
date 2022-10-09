//
//  MemorizeView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct MemorizeView: View {

    @ObservedObject var bibleVM: SwordMinder

    var passages: [Bible.Passage]

    init(bibleVM: SwordMinder) {
        self.bibleVM = bibleVM
        self.passages = [bibleVM.bible.passage(from: Bible.Reference(fromString: "Genesis 1:1"))!]
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(passages) { passage in
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
//        withAnimation {
////            let newItem = Item(context: viewContext)
////            newItem.timestamp = Date()
//
//            do {
////                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }

    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
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
//        }
    }
}

struct MemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        MemorizeView(bibleVM: SwordMinder())
    }
}
