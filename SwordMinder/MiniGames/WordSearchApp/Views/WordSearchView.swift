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
    @State private var settingsShown: Bool = false
    var passage: Passage
    
    @State var selectedTiles = Set<UUID>()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    settingsShown = true
                } label: {
                    Image(systemName: "gear")
                        .padding(5)
                }
                .buttonStyle(SMButtonStyle())
                .padding()
            }
            Text("Reference: \(passage.referenceFormatted)")
                .font(.headline)
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(wordSearch.grid, id: \.self) { row in
                    GridRow {
                        ForEach(row) { cell in
                            square(for: cell)
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
        .background(LinearGradient(colors: [.accentColor2, .accentColor3], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear {
            wordSearch.words = swordMinder.bible.words(for: passage)
                .filter { $0.count > 3 }
                .map { Word(text: $0) }
            wordSearch.makeGrid()
        }
        .sheet(isPresented: $settingsShown, onDismiss: { settingsShown = false }) {
            WordSearchSettingsView(difficulty: $wordSearch.difficulty)
        }
    }
    
    func square(for tile: Tile) -> some View {
        Rectangle()
            .foregroundColor(selectedTiles.contains(tile.id) ? .blue : .white)
            .border(.black, width: 1)
            .overlay(
                Text(String("\(tile.letter)"))
                    .font(.largeTitle)
                    .foregroundColor(selectedTiles.contains(tile.id) ? .white : .black)
            )
            .onTapGesture {
                withAnimation {
                    selectedTiles.toggleMembership(for: tile.id)
                }
            }
    }
}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView(wordSearch: WordSearch(), currentApp: .constant(.wordSearchApp), passage: Passage())
            .environmentObject(SwordMinder())
    }
}
