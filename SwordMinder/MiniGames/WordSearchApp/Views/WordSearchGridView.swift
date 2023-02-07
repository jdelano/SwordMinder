//
//  WordSearchGridView.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import SwiftUI
import AVFoundation

struct WordSearchGridView: View {
    @ObservedObject var wordSearch: WordSearch
    @EnvironmentObject var swordMinder: SwordMinder
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var passage: Passage
    @State var selectedTiles = Set<UUID>()
    @State var foundPipes = [PipeShape]()
    @State var cellSize = CGSize.zero
    @GestureState private var dragState = DragState.inactive
    @State private var highlighted: Set<UUID> = []
    @State private var showWin: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack {
            headerMenu
            grid
                .padding(.horizontal, 5)
            wordList
        }
        .background(Image("WordFindBackground"))
        .onAppear {
            Task { @MainActor in
                
                wordSearch.words = (try? await passage.words
                    .unique()
                    .filter { $0.count > 3 }
                    .map { Word(text: $0) }) ?? []
                wordSearch.makeGrid()
            }
        }
        .alert(isPresented: $showWin) {
            Alert(title: Text("You Won!"))
        }
        .foregroundColor(.white)
        .toolbar { toolbar }
        .navigationBarBackButtonHidden(true)
    }
    
    
    private var headerMenu: some View {
        HStack {
            Text("\(passage.referenceFormatted)")
            Spacer()
            Text("\(wordSearch.difficulty.rawValue)")
        }
        .font(.title2)
        .padding(.horizontal)
    }
    
    private var grid: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(wordSearch.gridSize)
            let cellHeight = geometry.size.height / CGFloat(wordSearch.gridSize)
            let cellSize = CGSize(width: cellWidth, height: cellHeight)
            let (startRow, startColumn) = gridLocation(point: dragState.startPoint, cellSize: cellSize, gridSize: wordSearch.gridSize)
            let (endRow, endColumn) = gridLocation(point: dragState.endPoint, cellSize: cellSize, gridSize: wordSearch.gridSize)
            ZStack {
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(0..<wordSearch.grid.count, id:\.self) { row in
                        GridRow {
                            ForEach(0..<wordSearch.grid.count, id:\.self) { column in
                                let highlightCell = dragState.isDragging && wordSearch
                                    .tilesInLine(from: (row: startRow, col: startColumn),
                                                 to: (row: endRow, col: endColumn))
                                    .contains(wordSearch.grid[row][column])
                                square(for: wordSearch.grid[row][column], highlighted: highlightCell, coord: (row: row, col: column))
                            }
                        }
                    }
                }
                .onChange(of: cellSize) { self.cellSize = $0 }
                if dragState.isDragging {
                    let (start, end) = gridPoints(start: dragState.startPoint, end: dragState.endPoint, cellSize: cellSize, gridSize: wordSearch.gridSize)
                    PipeShape(startPoint: start, endPoint: end, pipeWidth: DrawingConstants.pipeWidth)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.yellow)
                        .transition(AnyTransition.slide)
                }
                pipes
            }
            .gesture(dragGesture())
        }
    }
    
    
    private func gridLocation(point: CGPoint, cellSize: CGSize, gridSize: Int) -> (row: Int, col: Int) {
        if cellSize.width == 0.0 || cellSize.height == 0.0 { return (0, 0) }
        let cellY = Int(point.y / cellSize.height)
        let cellRow = cellY < 0 ? 0 : cellY > gridSize-1 ? gridSize-1 : cellY
        let cellX = Int(point.x / cellSize.width)
        let cellCol = cellX < 0 ? 0 : cellX > gridSize-1 ? gridSize-1 : cellX
        return (cellRow, cellCol)
    }
    
    private func gridPoints(start: CGPoint, end: CGPoint, cellSize: CGSize, gridSize: Int) -> (CGPoint, CGPoint) {
        let (startRow, startCol) = gridLocation(point: start, cellSize: cellSize, gridSize: gridSize)
        let (endRow, endCol) = gridLocation(point: end, cellSize: cellSize, gridSize: gridSize)
        let startX = CGFloat(startCol) * cellSize.width + cellSize.width/2
        let startY = CGFloat(startRow) * cellSize.height + cellSize.height/2
        let endX = CGFloat(endCol) * cellSize.width  + cellSize.width/2
        let endY = CGFloat(endRow) * cellSize.height + cellSize.height/2
        return (CGPoint(x: startX, y: startY), CGPoint(x: endX, y: endY))
    }
    
    @ViewBuilder
    private func square(for tile: Tile, highlighted: Bool, coord: (row: Int, col: Int)) -> some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 212/255, green: 175/255, blue: 55/255), Color(red: 193/255, green: 154/255, blue: 107/255)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: .black, radius: 2, x: 2, y: 2)
            .border(.black, width: 1)
            .overlay(
                Text(String("\(tile.letter)"))
                    .font(.largeTitle)
                    .font(.system(size: 8))
                    .foregroundColor(highlighted ? .white : .black)
            )
    }
    
    @ViewBuilder
    private var wordList: some View {
        VStack {
            Text("Words to Find")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(wordSearch.wordsUsed) { word in
                    Text(word.text.uppercased())
                        .fontWeight(.medium)
                        .strikethrough(word.found)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var pipes: some View {
        ForEach(foundPipes) { pipe in
            pipe
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
        }
    }
    
    private func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(start: drag.startLocation, current: drag.location)
            }
            .onEnded { drag in
                let (startRow, startCol) = gridLocation(point: drag.startLocation, cellSize: self.cellSize, gridSize: wordSearch.gridSize)
                let (endRow, endCol) = gridLocation(point: drag.location, cellSize: self.cellSize, gridSize: wordSearch.gridSize)
                let selectedTiles = wordSearch.tilesInLine(from: (row: startRow, col: startCol), to: (row: endRow, col: endCol))
                var found = false
                for word in wordSearch.wordsUsed {
                    let tilesForWord = wordSearch.tilesForWord(word.text)
                    if tilesForWord.count == selectedTiles.count && tilesForWord.allSatisfy({ selectedTiles.contains($0) }) {
                        if !word.found {
                            let (start, end) = gridPoints(start: drag.startLocation, end: drag.location, cellSize: cellSize, gridSize: wordSearch.gridSize)
                            withAnimation {
                                playSounds("right.wav")
                                foundPipes.append(PipeShape(startPoint: start, endPoint: end, pipeWidth: DrawingConstants.pipeWidth))
                            }
                        }
                        wordSearch.markWordFound(word)
                        found = true
                        break
                    }
                }
                if !found {
                    playSounds("wrong.wav")
                }
                if wordSearch.won {
                    let gems = wordSearch.difficulty == .easy ? 1 : wordSearch.difficulty == .medium ? 3 : 5
                    swordMinder.completeTask(difficulty: gems)
                    playSounds("win.wav")
                    showWin = true
                }
            }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Select Passage")
                }
                .foregroundColor(.white)
            }
        }
    }

    
    func playSounds(_ soundFileName : String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
            fatalError("Unable to find \(soundFileName) in bundle")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print(error.localizedDescription)
        }
        audioPlayer.play()
    }

    struct DrawingConstants {
        static let pipeWidth: CGFloat = 30.0
        static let pipePadding: CGFloat = 10.0
    }
}

struct WordSearchGridView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchGridView(wordSearch: WordSearch(), passage: Passage(fromString: "John 3:17", version: .niv)!)
            .environmentObject(SwordMinder())
    }
}

