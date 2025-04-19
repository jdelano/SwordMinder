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
    @State var reference: Reference
        
    // onChanged event handlers for each part of the reference
    var referenceChanged: ((_ reference: Reference) -> Void)?
    
    var body: some View {
        HStack(alignment: .top) {
            Picker("", selection: $reference.book) {
                ForEach(Book.allCases, id:\.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.menu)
            .frame(minWidth: VerseConstants.bookPickerWidth)
            picker(for: Array(1...reference.lastChapter), selection: $reference.chapter)
            picker(for: Array(1...reference.lastVerse), selection: $reference.verse)
        }
        .onChange(of: reference) { _, newref in
            fixPicker(for: newref)
            referenceChanged?(newref)
        }
    }
    
    private func fixPicker(for reference: Reference) {
        let maxChapters = reference.lastChapter
        if maxChapters < reference.chapter && maxChapters != 0 {
            withAnimation {
                self.reference.chapter = maxChapters
            }
        }
        let maxVerses = reference.lastVerse
        if maxVerses < reference.verse && maxVerses != 0 {
            withAnimation {
                self.reference.verse = maxVerses
            }
        }
    }
    
    private func picker<Element : Hashable>(for items: [Element], selection: Binding<Element>) -> some View {
        Picker("", selection: selection) {
            ForEach(items, id:\.self) { item in
                Text(String(describing: item)).tag(item)
            }
        }
        .pickerStyle(.menu)
    }
    
    private struct VerseConstants {
        static let bookPickerWidth: CGFloat = 170
        static let chapterPickerWidth: CGFloat = 60
        static let versePickerWidth: CGFloat = 60
    }
}

struct VersePicker_Previews: PreviewProvider {
    static var previews: some View {
        VersePickerView(reference: Reference(book: .psalms, chapter: 119, verse: 100))
            .environmentObject(SwordMinder())
    }
}
