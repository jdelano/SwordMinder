//
//  MemoryTileViewModel.swift
//  SwordMinder
//
//  Created by John Delano on 4/16/25.
//
import UniformTypeIdentifiers
import Foundation

/// ViewModel handling game logic
/// ViewModel handling memory-tile game logic
class MemoryTileViewModel: ObservableObject {
    @Published var sourceTiles: [MemoryTile] = []
    @Published var trays: [MemoryTile?] = []
    private var correctOrder: [MemoryTile] = []
    
    /// Default initializer; call `load(verse:)` when you have text
    init() {}
    
    /// Split the verse into tiles, shuffle, and reset trays
    func load(verse: String) {
        let words = verse
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        correctOrder = words.map { MemoryTile(text: $0) }
        sourceTiles = correctOrder.shuffled()
        trays = Array(repeating: nil, count: correctOrder.count)
    }
    
    /// Handle dropping a tile (by its id-string) into a tray
    func handleDrop(idString: String, at trayIndex: Int) {
        guard let uuid = UUID(uuidString: idString),
              let tile = sourceTiles.first(where: { $0.id == uuid })
        else { return }
        // Remove from source
        sourceTiles.removeAll(where: { $0.id == uuid })
        // Return any existing tile in the tray
        if let existing = trays[trayIndex] {
            sourceTiles.append(existing)
        }
        // Place the new tile
        trays[trayIndex] = tile
    }
    
    /// Win when placed tiles exactly match the original order
    var isWin: Bool {
        let placed = trays.compactMap { $0 }
        return placed == correctOrder
    }
    
    /// Reset to a fresh shuffled board
    func resetGame() {
        sourceTiles = correctOrder.shuffled()
        trays = Array(repeating: nil, count: correctOrder.count)
    }
}
