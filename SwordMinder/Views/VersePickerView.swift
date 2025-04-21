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
        HStack(alignment: .top, spacing: 16) {
            Picker("", selection: bookBinding) {
                ForEach(Book.allCases, id:\.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.menu)
            .frame(minWidth: VerseConstants.bookPickerWidth)
            .accessibilityLabel("Bible Book Picker")
            .animation(.easeInOut, value: reference.book)
            
            picker(for: Array(1...reference.lastChapter), selection: chapterBinding)
                .accessibilityLabel("Chapter Picker")
                .animation(.easeInOut, value: reference.chapter)
            
            picker(for: Array(1...reference.lastVerse), selection: verseBinding)
                .accessibilityLabel("Verse Picker")
                .animation(.easeInOut, value: reference.verse)
        }
        .onChange(of: reference) { _, newref in
            referenceChanged?(newref)
        }
    }
    
    private var bookBinding: Binding<Book> {
        Binding<Book>(
            get: { reference.book },
            set: { newBook in
                reference.book = newBook
                reference.chapter = min(reference.chapter, reference.lastChapter)
                reference.verse = min(reference.verse, reference.lastVerse)
            }
        )
    }
    
    private var chapterBinding: Binding<Int> {
        Binding<Int>(
            get: { reference.chapter },
            set: { newChapter in
                reference.chapter = newChapter
                reference.verse = min(reference.verse, reference.lastVerse)
            }
        )
    }
    
    private var verseBinding: Binding<Int> {
        Binding<Int>(
            get: { reference.verse },
            set: { newVerse in
                reference.verse = newVerse
            }
        )
    }
    
    private func picker<Element : Hashable>(for items: [Element], selection: Binding<Element>) -> some View {
        Picker("", selection: selection) {
            ForEach(items, id:\.self) { item in
                Text(String(describing: item)).tag(item)
            }
        }
        .pickerStyle(.menu)
        .frame(width: VerseConstants.chapterVersePickerWidth)
    }
}

private struct VerseConstants {
    static let bookPickerWidth: CGFloat = 170
    static let chapterVersePickerWidth: CGFloat = 70
}

#Preview {
    @Previewable @State var reference: Reference = Reference(book: .psalms, chapter: 119, verse: 148)
    VersePickerView(reference: reference)
        .environmentObject(SwordMinder())
}
