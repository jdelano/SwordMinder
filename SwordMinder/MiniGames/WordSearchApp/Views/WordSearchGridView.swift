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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var passage: Passage
    @State var selectedTiles = Set<UUID>()
    @State var foundPipes = [Pipe]()
    @State var cellSize = CGSize.zero
    @GestureState private var dragState = DragState.inactive
    @State private var highlighted: Set<UUID> = []
    @State private var showWin: Bool = false
    @State var audioPlayer = AVPlayer()
    @State private var countDown = 0
    @State private var timer: Timer?
    
    private var remainingTime: Int {
        60 * wordSearch.difficultyMultipler - countDown
    }
    
    var body: some View {
        VStack {
            headerMenu
            if verticalSizeClass == .regular {
                grid
                    .padding(.horizontal, 5)
                wordList
            } else {
                GeometryReader { geometry in
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.fixed(250.0))]) {
                        grid
                            .padding(.horizontal, 5)
                            .frame(height: geometry.size.height)
                        wordList
                    }
                }
                
            }
        }
        .background(Image("WordFindBackground")
            .rotationEffect(.degrees(verticalSizeClass == .regular ? 0.0 : 90.0)))
        .onAppear {
            Task { @MainActor in
                
                wordSearch.words = (try? await passage.words
                    .unique()
                    .filter { $0.count > 3 }
                    .map { Word(text: $0) }) ?? []
                wordSearch.makeGrid()
                startTimer()
            }
        }
        .alert(isPresented: $showWin) {
            Alert(title: Text("You won!"))
        }
        .foregroundColor(.white)
        .toolbar { toolbar }
        .navigationBarBackButtonHidden(true)
    }
    
    
    private var headerMenu: some View {
        HStack {
            Text("\(passage.referenceFormatted)")
            Spacer()
            Text("\(countDown / 60):\(String(format: "%02d", countDown % 60))")
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
            let (startRow, startColumn) = gridLocation(for: dragState.startPoint, cellSize: cellSize, gridSize: wordSearch.gridSize)
            let (endRow, endColumn) = gridLocation(for: dragState.endPoint, cellSize: cellSize, gridSize: wordSearch.gridSize)
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
                }
                pipes
            }
            .gesture(dragGesture())
        }
    }
    
    
    private func gridLocation(for point: CGPoint, cellSize: CGSize, gridSize: Int) -> (row: Int, col: Int) {
        if cellSize.width == 0.0 || cellSize.height == 0.0 { return (0, 0) }
        let cellY = Int(point.y / cellSize.height)
        let cellRow = cellY < 0 ? 0 : cellY > gridSize-1 ? gridSize-1 : cellY
        let cellX = Int(point.x / cellSize.width)
        let cellCol = cellX < 0 ? 0 : cellX > gridSize-1 ? gridSize-1 : cellX
        return (cellRow, cellCol)
    }
    
    private func cellCenter(for rowCol: (row: Int, col: Int), cellSize: CGSize, gridSize: Int) -> CGPoint {
        CGPoint(x: CGFloat(rowCol.col) * cellSize.width + cellSize.width/2,
                y: CGFloat(rowCol.row) * cellSize.height + cellSize.height/2)
    }
    
    private func gridPoints(start: CGPoint, end: CGPoint, cellSize: CGSize, gridSize: Int) -> (CGPoint, CGPoint) {
        let (startRow, startCol) = gridLocation(for: start, cellSize: cellSize, gridSize: gridSize)
        let (endRow, endCol) = gridLocation(for: end, cellSize: cellSize, gridSize: gridSize)
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
            let start = cellCenter(for: (pipe.startRow, pipe.startCol), cellSize: cellSize, gridSize: wordSearch.gridSize)
            let end = cellCenter(for: (pipe.endRow, pipe.endCol), cellSize: cellSize, gridSize: wordSearch.gridSize)
            PipeShape(startPoint: start, endPoint: end, pipeWidth: DrawingConstants.pipeWidth)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(pipe.found ? .blue : .yellow)
                .transition(AnyTransition.opacity)
        }
    }
    
    private func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(start: drag.startLocation, current: drag.location)
            }
            .onEnded { drag in
                let (startRow, startCol) = gridLocation(for: drag.startLocation, cellSize: self.cellSize, gridSize: wordSearch.gridSize)
                let (endRow, endCol) = gridLocation(for: drag.location, cellSize: self.cellSize, gridSize: wordSearch.gridSize)
                let selectedTiles = wordSearch.tilesInLine(from: (row: startRow, col: startCol), to: (row: endRow, col: endCol))
                var found = false
                for word in wordSearch.wordsUsed {
                    let tilesForWord = wordSearch.tilesForWord(word.text)
                    if tilesForWord.count == selectedTiles.count && tilesForWord.allSatisfy({ selectedTiles.contains($0) }) {
                        if !word.found {
                            withAnimation {
                                playSound("right.wav")
                                foundPipes.append(Pipe(startRow: startRow, startCol: startCol, endRow: endRow, endCol: endCol, found: true))
                            }
                        }
                        wordSearch.markWordFound(word)
                        found = true
                        break
                    }
                }
                if !found {
                    playSound("wrong.wav")
                }
                if wordSearch.won {
                    let gems = wordSearch.difficulty == .easy ? 1 : wordSearch.difficulty == .medium ? 3 : 5
                    swordMinder.completeTask(difficulty: gems)
                    playSound("win.wav")
                    stopTimer()
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
    
    func startTimer() {
        countDown = 60 * wordSearch.difficultyMultipler
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.countDown == 0 {
                playSound("outoftime.wav")
                timer.invalidate()
            } else {
                self.countDown -= 1
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    
    func playSound(_ soundFileName : String) {
        if let url = Bundle.main.url(forResource: soundFileName, withExtension: nil) {
            audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
            audioPlayer.play()
        }
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

