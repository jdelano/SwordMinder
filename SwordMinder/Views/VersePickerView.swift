//
//  VersePickerView.swift
//  SwordMinder
//
//  Created by John Delano on 6/24/22.
//
import SwiftUI

/// View to display picker wheels for a `Bible.Reference`.
/// The pickers will display the correct number of chapters for each book selected, and the correct number of verses for each book and chapter that was selected
struct VersePickerView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var reference: Reference
        
    // onChanged event handlers for each part of the reference
    var referenceChanged: ((_ reference: Reference) -> Void)?
    
    var body: some View {
        HStack(alignment: .top) {
            wheelPicker(for: Book.names, title: "Book", selection: $reference.book.name)
                .frame(minWidth: VerseConstants.bookPickerWidth)
            wheelPicker(for: swordMinder.bible.chapters(in: reference.book), title: "Chapter", selection: $reference.chapter)
                .frame(minWidth: VerseConstants.chapterPickerWidth)
            wheelPicker(for: swordMinder.bible.verses(in: reference.book, chapter: reference.chapter), title: "Verse", selection: $reference.verse)
                .frame(minWidth: VerseConstants.versePickerWidth)
        }
        .onChange(of: reference) { ref in
            fixPicker(for: ref)
            referenceChanged?(ref)
        }
        .overlay(!swordMinder.isLoaded ? ProgressView() : nil)
    }
    
    private func fixPicker(for reference: Reference) {
        let maxChapters = swordMinder.bible.chapters(in: reference.book).count
        if maxChapters < reference.chapter && maxChapters != 0 {
            withAnimation {
                self.reference.chapter = maxChapters
            }
        }
        let maxVerses = swordMinder.bible.verses(in: reference.book, chapter: reference.chapter).count
        if maxVerses < reference.verse && maxVerses != 0 {
            withAnimation {
                self.reference.verse = maxVerses
            }
        }
    }
    
    private func wheelPicker<Element : Hashable>(for items: [Element], title: String, selection: Binding<Element>) -> some View {
        Picker(title, selection: selection) {
            ForEach(items, id:\.self) { item in
                Text(String(describing: item)).tag(item)
            }
        }
        .pickerStyle(.wheel)
    }
    
    private struct VerseConstants {
        static let bookPickerWidth: CGFloat = 200
        static let chapterPickerWidth: CGFloat = 60
        static let versePickerWidth: CGFloat = 60
    }
}

struct VersePicker_Previews: PreviewProvider {
    static var previews: some View {
        VersePickerView(reference: .constant(Reference(book: Book(named: "Psalms")!, chapter: 119, verse: 100)))
            .environmentObject(SwordMinder())
    }
}
