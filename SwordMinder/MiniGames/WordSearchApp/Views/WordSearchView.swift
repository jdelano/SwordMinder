//
//  WordSearchView.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import SwiftUI

struct WordSearchView: View {
    @ObservedObject var wordSearch: WordSearch
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    var body: some View {
        VStack {
            Grid {
                ForEach(wordSearch.grid, id: \.self) { row in
                    GridRow {
                        ForEach(row, id: \.self) { column in
                            Text(String("\(column)"))
                                .font(.largeTitle)
                        }
                    }
                }
            }
            Button {
                currentApp = .swordMinder
            } label: {
                Text("Return to Sword Minder")
            }
            .padding()
            .buttonStyle(SMButtonStyle())
        }
        .onAppear {
            let verseText = swordMinder.bible.text(for: Passage())
            wordSearch.words = verseText.split(separator: " ").map { Word(text: String($0)) }
            wordSearch.makeGrid()
        }
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView(wordSearch: WordSearch(), currentApp: .constant(.wordSearchApp))
            .environmentObject(SwordMinder())
    }
}
