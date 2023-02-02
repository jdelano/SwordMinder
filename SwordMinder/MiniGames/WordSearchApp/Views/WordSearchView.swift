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
    @State private var currentDragBounds: CGRect?

    
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
        ZStack {
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
            if self.currentDragBounds != nil {
                Rectangle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: self.currentDragBounds!.width, height: self.currentDragBounds!.height)
                    .position(x: self.currentDragBounds!.midX, y: self.currentDragBounds!.midY)
//                    .rotationEffect(Angle(radians: atan2(self.currentDragBounds!.height, self.currentDragBounds!.width)))
            }
        }
        .gesture(dragGesture())
    }

    @ViewBuilder
    private func square(for tile: Tile) -> some View {
        GeometryReader { geometry in
            let selected = false //self.currentDragBounds!.intersects(geometry.frame(in: .global))
            Rectangle()
                .foregroundColor(selected ? .blue : .white)
                .border(.black, width: 1)
                .overlay(
                    Text(String("\(tile.letter)"))
                        .font(.largeTitle)
                        .foregroundColor(selected ? .white : .black)
                )
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
    
    private func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let width = 10
                let height = abs(value.location.y - value.startLocation.y)
                let xMin = min(value.location.x, value.startLocation.x)
                let xMax = max(value.location.x, value.startLocation.x)
                let yMin = min(value.location.y, value.startLocation.y)
                let yMax = max(value.location.y, value.startLocation.y)
                let rect = CGRect(x: xMin, y: yMin, width: xMax - xMin, height: yMax - yMin)
                let angle = atan2(value.location.y - value.startLocation.y, value.location.x - value.startLocation.x)
                let rotatedRect = rect.applying(CGAffineTransform(rotationAngle: angle))
                
                self.currentDragBounds = rect
                //                self.highlighted = self.rects.enumerated().compactMap { index, rect in
                //                    return rotatedRect.intersects(rect) ? index : nil
                //                }
            }
            .onEnded { value in
                self.currentDragBounds = nil
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
        WordSearchView(wordSearch: WordSearch(), currentApp: .constant(.wordSearchApp), passage: Passage(fromString: "John 3:17", version: .niv)!)
            .environmentObject(SwordMinder())
    }
}

