//
//  VersePicker.swift
//  SwordMinder
//
//  Created by John Delano on 6/24/22.
//
import SwiftUI

/// UIPickerView extension to allow Pickers to fit three-wide.
extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)
    }
}


/// View to display picker wheels for book, chapter, and verse.
/// The pickers will display the correct number of chapters for each book selected, and the correct number of verses for each book and chapter that was selected
struct VersePicker: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var reference: Bible.Reference
    
    // books, chapters, and verses to populate the three pickers with options
    @State var books: [String] = []
    @State var chapters: [Int] = []
    @State var verses: [Int] = []
    
    // onChanged event handlers for each part of the reference
    var bookChanged: ((_ book: Bible.Book) -> Void)?
    var chapterChanged: ((_ chapter: Int) -> Void)?
    var verseChanged: ((_ verse: Int) -> Void)?
    
    var body: some View {
        HStack(alignment: .top) {
            wheelPicker(for: books, title: "Book", selection: $reference.book.name)
                .onChange(of: reference.book) { newBook in
                    withAnimation {
                        reference.chapter = 1
                        reference.verse = 1
                        refresh()
                    }
                    bookChanged?(newBook)
                }
            wheelPicker(for: chapters, title: "Chapter", selection: $reference.chapter)
                .onChange(of: reference.chapter) { newChapter in
                    withAnimation {
                        reference.verse = 1
                        refresh()
                    }
                    chapterChanged?(newChapter)
                }
            wheelPicker(for: verses, title: "Verse", selection: $reference.verse)
                .onChange(of: reference.verse) { newVerse in
                    verseChanged?(newVerse)
                }
        }
        .overlay(!swordMinder.isLoaded ? ProgressView() : nil)
        .onChange(of: swordMinder.isLoaded, perform: { loaded in
            if loaded { refresh() }
        })
        .onAppear {
            withAnimation {
                refresh()
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
    
    
    /// Updates the books, chapters, and verses vars. Called when the picker selection changes
    private func refresh() {
        books = swordMinder.bible.bookNames
        chapters = swordMinder.bible.chapters(in: reference.book)
        verses = swordMinder.bible.verses(in: reference.book, chapter: reference.chapter)
    }
}

struct VersePicker_Previews: PreviewProvider {
    static var previews: some View {
        VersePicker(reference: .constant(Bible.reference()))
            .environmentObject(SwordMinder())
    }
}
