//
//  WordSearchGridView.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import SwiftUI
import AVFoundation

struct WordSearchGridView: View {
    @ObservedObject var wordSearch: WordSearchGame
    @EnvironmentObject var swordMinder: SwordMinder
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var passage: Passage
    @State var cellSize = CGSize.zero
    @GestureState private var dragState = DragState.inactive
    @State private var showWin: Bool = false
    @State var audioPlayer = AVPlayer()
    
    var body: some View {
        VStack {
            headerMenu
            if verticalSizeClass == .regular {
                grid
                    .padding(.horizontal, DrawingConstants.gridPadding)
                wordList
            } else {
                GeometryReader { geometry in
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.fixed(DrawingConstants.wordListLandscapeMinWidth))]) {
                        grid
                            .padding(.horizontal, DrawingConstants.gridPadding)
                            .frame(height: geometry.size.height)
                        wordList
                    }
                }
                
            }
        }
        .background(Image("WordFindBackground")
            .rotationEffect(.degrees(verticalSizeClass == .regular ? 0.0 : 90.0))
        )
        .onAppear {
            wordSearch.startGame(passage: passage) { timer in
                playSound("outoftime.wav")
            }
        }
        .alert(isPresented: $showWin) {
            Alert(title: Text("You won!"))
        }
        .foregroundColor(.white)
        .toolbar { toolbar }
        .navigationBarBackButtonHidden(true)
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

    private var headerMenu: some View {
        HStack {
            Text("\(passage.referenceFormatted)")
            Spacer()
            timeRemaining
            Spacer()
            Text("\(wordSearch.difficulty.rawValue)")
        }
        .font(.title2)
        .padding(.horizontal)
    }
    
    private var timeRemaining: some View {
        Text("\(wordSearch.timeRemaining / 60):\(String(format: "%02d", wordSearch.timeRemaining % 60))")
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
                                    .tilesInLine(from: (startRow, startColumn),
                                                 to: (endRow, endColumn))
                                    .contains(wordSearch.grid[row][column])
                                square(for: wordSearch.grid[row][column], highlighted: highlightCell, coord: (row, column))
                            }
                        }
                    }
                }
                .onChange(of: cellSize) { self.cellSize = $0 }
                let (start, end) = pipeCoordinates(start: dragState.startPoint, end: dragState.endPoint, cellSize: cellSize, gridSize: wordSearch.gridSize)
                PipeShape(startPoint: start, endPoint: end, pipeWidth: DrawingConstants.pipeWidth)
                    .stroke(style: StrokeStyle(lineWidth: DrawingConstants.pipeBorder, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .opacity(dragState.isDragging ? 1.0 : 0.0)                    
                pipes
            }
            .gesture(dragGesture())
        }
    }
    
    
    @ViewBuilder
    private func square(for tile: Tile, highlighted: Bool, coord: (row: Int, col: Int)) -> some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color("WordFindTileColor1"), Color("WordFindTileColor2")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: .black, radius: DrawingConstants.gridCellShadow, x: DrawingConstants.gridCellShadow, y: DrawingConstants.gridCellShadow)
            .border(.black, width: DrawingConstants.gridCellBorder)
            .overlay(
                Text(String("\(tile.letter)"))
                    .font(.largeTitle)
                    .font(.system(size: DrawingConstants.gridFontSize))
                    .foregroundColor(highlighted ? .white : .black)
            )
    }
    
    @ViewBuilder
    private var wordList: some View {
        VStack {
            Text("Words to Find")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: DrawingConstants.minimumWordListColumnWidth))]) {
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
        ForEach(wordSearch.foundPipes) { pipe in
            let start = cellCenter(for: (pipe.startRow, pipe.startCol), cellSize: cellSize, gridSize: wordSearch.gridSize)
            let end = cellCenter(for: (pipe.endRow, pipe.endCol), cellSize: cellSize, gridSize: wordSearch.gridSize)
            PipeShape(startPoint: start, endPoint: end, pipeWidth: DrawingConstants.pipeWidth)
                .stroke(style: StrokeStyle(lineWidth: pipe.new ? DrawingConstants.pipeBorderHighlight : DrawingConstants.pipeBorder, lineCap: .round, lineJoin: .round))
                .animation(.linear(duration: DrawingConstants.pipeHighlightAnimationLength), value: pipe.new)
                .foregroundColor(pipe.found ? .blue : .yellow)
        }
    }
    
    /// Drag gesture for word search game to allow user to select words in the grid
    /// - Returns: The `Gesture` to use
    private func dragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(start: drag.startLocation, current: drag.location)
            }
            .onEnded { drag in
                // Get the tiles that the user selected during the drag gesture; need the (row,col) coordinates that correspond to the drag gesture first.
                let (startRow, startCol) = gridLocation(for: drag.startLocation, cellSize: self.cellSize, gridSize: wordSearch.gridSize)
                let (endRow, endCol) = gridLocation(for: drag.location, cellSize: self.cellSize, gridSize: wordSearch.gridSize)
                let selectedTiles = wordSearch.tilesInLine(from: (row: startRow, col: startCol), to: (row: endRow, col: endCol))
                // This is used to know which sound effect to play later on; default is no match
                var found = false
                // Search through each word in the wordsUsed array to see if the tiles that were selected during the drag match all the tiles in any of the words
                for word in wordSearch.wordsUsed {
                    let tilesForWord = wordSearch.tilesForWord(word.text)
                    // As long as we have the same number of tiles selected as are in the word, and all selected tiles contain the tiles for the word, then the user has found this word in the grid.
                    if tilesForWord.count == selectedTiles.count && tilesForWord.allSatisfy({ selectedTiles.contains($0) }) {
                        // Make sure the user didn't already find this word
                        if !word.found {
                            withAnimation {
                                playSound("right.wav")
                                wordSearch.addPipe(start: (startRow, startCol), end: (endRow, endCol))
                            }
                            wordSearch.markWordFound(word)
                            found = true
                        }
                        // Don't need to continue looking through the list if this word matches their selection
                        break
                    }
                }
                if !found {
                    playSound("wrong.wav")
                }
                // Check to see if they won the game
                if wordSearch.won {
                    // Award gems based on difficulty level and if there is still time remaining
                    if wordSearch.timeRemaining > 0 {
                        swordMinder.completeTask(difficulty: wordSearch.difficultyMultipler)
                    }
                    playSound("win.wav")
                    wordSearch.stopAllTimers()
                    showWin = true
                }
            }
    }
    
    
    /// Retrieves the row/column of the cell at the specified `CGPoint`
    /// - Parameters:
    ///   - point: The `CGPoint` used to find the row/column
    ///   - cellSize: The size of each grid cell
    ///   - gridSize: The number of rows/columns in the grid (the grid is assumed to be square)
    /// - Returns: A tuple of row/column indexes for the grid cell that intersects with the supplied point.
    private func gridLocation(for point: CGPoint, cellSize: CGSize, gridSize: Int) -> (row: Int, col: Int) {
        // It's possible the word grid hasn't been formed yet, because word list hasn't loaded yet
        if cellSize.width == 0.0 || cellSize.height == 0.0 { return (0, 0) }
        let cellY = Int(point.y / cellSize.height)
        // Make sure row stays within the bounds of the grid
        let cellRow = cellY < 0 ? 0 : cellY > gridSize-1 ? gridSize-1 : cellY
        let cellX = Int(point.x / cellSize.width)
        // Make sure row stays within the bounds of the grid
        let cellCol = cellX < 0 ? 0 : cellX > gridSize-1 ? gridSize-1 : cellX
        return (cellRow, cellCol)
    }
    
    /// Returns the coordinate (in pixels) that correspond to the specified cell at the given row and column number
    /// - Parameters:
    ///   - rowCol: The row and column index of the cell
    ///   - cellSize: The size of each grid cell
    ///   - gridSize: The number of rows/columns in the grid (the grid is assumed to be square)
    /// - Returns: The `CGPoint` at the center of the specified grid cell
    private func cellCenter(for rowCol: (row: Int, col: Int), cellSize: CGSize, gridSize: Int) -> CGPoint {
        CGPoint(x: CGFloat(rowCol.col) * cellSize.width + cellSize.width/2,
                y: CGFloat(rowCol.row) * cellSize.height + cellSize.height/2)
    }
    
    /// Returns the pipe coordinates for the given start and end coordinates. Pipe coordinates are calculated so that each end of the pipe is centered on the grid cell that intersects with the given point.
    /// - Parameters:
    ///   - start: The coordinate (in pixels) of the starting point for the line
    ///   - end: The coordinate (in pixels) of the ending point for the line
    ///   - cellSize: The size of each grid cell
    ///   - gridSize: The number of rows/columns in the grid (the grid is assumed to be square)
    /// - Returns: A tuple of `CGPoint` representing the coordinates of the line that connects the centers of the cells mapped to the supplied start and end points
    private func pipeCoordinates(start: CGPoint, end: CGPoint, cellSize: CGSize, gridSize: Int) -> (CGPoint, CGPoint) {
        let (startRow, startCol) = gridLocation(for: start, cellSize: cellSize, gridSize: gridSize)
        let (endRow, endCol) = gridLocation(for: end, cellSize: cellSize, gridSize: gridSize)
        let start = cellCenter(for: (startRow, startCol), cellSize: cellSize, gridSize: gridSize)
        let end = cellCenter(for: (endRow, endCol), cellSize: cellSize, gridSize: gridSize)
        return (start, end)
    }
    
    /// Plays the sound file provided, replacing any currently playing sounds.
    /// - Parameter soundFileName: A string representation of the file name (including extension)
    private func playSound(_ soundFileName : String) {
        if let url = Bundle.main.url(forResource: soundFileName, withExtension: nil) {
            audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
            audioPlayer.play()
        }
    }
    
    /// "Magic" numbers for this view
    private struct DrawingConstants {
        static let pipeWidth: CGFloat = 30.0
        static let pipePadding: CGFloat = 10.0
        static let pipeBorder: CGFloat = 3.0
        static let pipeBorderHighlight: CGFloat = 5.0
        static let pipeHighlightAnimationLength: CGFloat = 0.10
        static let minimumWordListColumnWidth: CGFloat = 100.0
        static let gridFontSize: CGFloat = 8.0
        static let gridCellBorder: CGFloat = 1.0
        static let gridCellShadow: CGFloat = 2.0
        static let gridPadding: CGFloat = 5.0
        static let wordListLandscapeMinWidth: CGFloat = 250.0
    }
}

struct WordSearchGridView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchGridView(wordSearch: WordSearchGame(), passage: Passage(fromString: "John 3:16", toString: "John 3:17", version: .niv)!)
            .environmentObject(SwordMinder())
    }
}

