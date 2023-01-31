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
    @State var passage: Passage
    
    @GestureState private var location: CGPoint = .zero
    @State private var highlighted: Set<UUID> = []

    
    @State var selectedTiles = Set<UUID>()
    
    var body: some View {
        VStack {
            headerMenu
            Text("Reference: \(passage.referenceFormatted)")
                .font(.headline)
            grid
            wordList
            returnButton
        }
        .background(LinearGradient(colors: [.accentColor2, .accentColor3], startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear {
            Task { @MainActor in
                wordSearch.words = (try? await passage.words.filter { $0.count > 3 }
                    .map { Word(text: $0) }) ?? []
                wordSearch.makeGrid()
            }
        }
        .sheet(isPresented: $settingsShown, onDismiss: { settingsShown = false }) {
            WordSearchSettingsView(difficulty: $wordSearch.difficulty)
        }
    }
    
    
    private var headerMenu: some View {
        HStack {
            Text("Difficulty: \(wordSearch.difficulty.rawValue)")
                .padding(.leading)
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
    }
    
    private var grid: some View {
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
    }

    @ViewBuilder
    private func square(for tile: Tile) -> some View {
        GeometryReader { geometry in
            let selected = geometry.frame(in: .global).contains(self.location)
            Rectangle()
                .foregroundColor(selected ? .blue : .white)
                .border(.black, width: 1)
                .overlay(
                    Text(String("\(tile.letter)"))
                        .font(.largeTitle)
                        .foregroundColor(selected ? .white : .black)
                )
                .gesture(dragGesture(tile: tile))
        }
    }

    
    @ViewBuilder
    private var wordList: some View {
        Text("Words to Find:")
            .font(.headline)
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(wordSearch.wordsUsed) { word in
                Text(word.text.uppercased())
            }
        }
    }
    
    private var returnButton: some View {
        Button {
            currentApp = .swordMinder
        } label: {
            Text("Return to Sword Minder")
                .padding()
        }
        .padding()
        .buttonStyle(SMButtonStyle())
    }
    
    private func dragGesture(tile: Tile) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .updating($location) { (value, state, transaction) in
                state = value.location
            }
            .onEnded { _ in
                
            }
    }
    
    @ViewBuilder
    func tileReader(tile: Tile) -> some View {
        GeometryReader { geometry in
            if geometry.frame(in: .global).contains(self.location) {
//                self.highlighted = index
            }
            AnyView(Rectangle().fill(Color.clear))
        }
    }

}

struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView(wordSearch: WordSearch(), currentApp: .constant(.wordSearchApp), passage: Passage())
            .environmentObject(SwordMinder())
    }
}

