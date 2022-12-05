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
    var passage: Passage
    
    @State var selectedTiles = Set<UUID>()
    
    var body: some View {
        VStack {
            Text("Reference: \(passage.referenceFormatted)")
                .font(.headline)
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(wordSearch.grid, id: \.self) { row in
                    GridRow {
                        ForEach(row) { cell in
                            Rectangle()
                                .foregroundColor(selectedTiles.contains(cell.id) ? .blue : .white)
                                .border(.black, width: 1)
                                .overlay(
                                    Text(String("\(cell.letter)"))
                                        .font(.largeTitle)
                                        .foregroundColor(selectedTiles.contains(cell.id) ? .white : .black)
                                )
                                .onTapGesture {
                                    selectedTiles.toggleMembership(for: cell.id)
                                }
                        }
                    }
                }
            }
            .padding()
            Text("Words to Find:")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(wordSearch.wordsUsed) { word in
                    Text(word.text.uppercased())
                }
            }
            Button {
                currentApp = .swordMinder
            } label: {
                Text("Return to Sword Minder")
                    .padding()
            }
            .padding()
            .buttonStyle(SMButtonStyle())
        }
        .onAppear {
            wordSearch.words = swordMinder.bible.words(for: passage)
                .filter { $0.count > 3 }
                .map { Word(text: $0) }
            wordSearch.makeGrid()
        }
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView(wordSearch: WordSearch(), currentApp: .constant(.wordSearchApp), passage: Passage())
            .environmentObject(SwordMinder())
    }
}
