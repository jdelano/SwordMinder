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
            wordSearch.words = swordMinder.bible.words(for: passage)
                .filter { $0.count > 3 }
                .map { Word(text: $0) }
            wordSearch.makeGrid()
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


//struct PlayerView: View {
//    var scaled: Bool = false
//    var player: Player = Player(name: "Phile", color: .green, age: 42)
//    
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            Rectangle().frame(width: 100, height: 100).foregroundColor(player.color).cornerRadius(15.0).scaleEffect(scaled ? 1.5 : 1)
//            
//            VStack {
//                Text(player.name)
//                Text("Age: \(player.age)")
//            }.padding([.top, .leading], 10)
//        }.zIndex(scaled ? 2 : 1)
//    }
//}
//
//
//struct ContentView: View {
//    @EnvironmentObject var data: PlayerData
//    
//
//    private var Content: some View {
//        VStack {
//            HStack {
//                ForEach(0..<3) { i in
//                    PlayerView(scaled: self.highlighted == i, player: self.data.players[i])
//                        .background(self.rectReader(index: i))
//                }
//            }
//            .zIndex((0..<3).contains(highlighted ?? -1) ? 2 : 1)
//            
//            HStack {
//                ForEach(3..<6) { i in
//                    PlayerView(scaled: self.highlighted == i, player: self.data.players[i])
//                        .background(self.rectReader(index: i))
//                }
//            }
//            .zIndex((3..<6).contains(highlighted ?? -1) ? 2 : 1)
//        }
//    }
//    
//    func rectReader(index: Int) -> some View {
//        return GeometryReader { (geometry) -> AnyView in
//            if geometry.frame(in: .global).contains(self.location) {
//                DispatchQueue.main.async {
//                    self.highlighted = index
//                }
//            }
//            return AnyView(Rectangle().fill(Color.clear))
//        }
//    }
//    
//    var body: some View {
//        Content
//            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                .updating($location) { (value, state, transaction) in
//                    state = value.location
//                }.onEnded {_ in
//                    self.highlighted = nil
//                })
//    }
//}
