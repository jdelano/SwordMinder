import SwiftUI

import SwiftUI
import UniformTypeIdentifiers

struct MemoryTileView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @ObservedObject var viewModel = MemoryTileViewModel()
    @Binding var currentApp: Apps
    
    @State private var loadedVerse: String = ""
    
    /// Async load passage text and initialize tiles
    @MainActor
    private func loadVerse() async {
        guard let passage = swordMinder.passages.first else { return }
        // Assume `text` is an async getter on Passage
        let text = try? await passage.text()
        loadedVerse = text ?? ""
        viewModel.load(verse: loadedVerse)
    }
    
    var body: some View {
        VStack {
            Button("Return to SwordMinder!") {
                withAnimation { currentApp = .swordMinder }
            }
            VStack(spacing: 20) {
                if loadedVerse.isEmpty {
                    ProgressView("Loading verse…")
                        .task { await loadVerse() }
                } else {
                    Text("Arrange the verse")
                        .font(.title2)
                    
                    // 1) Scrollable, height‑constrained tile grid
                    ScrollView {
                        LazyVGrid(columns: [ GridItem(.adaptive(minimum: 80)) ], spacing: 10) {
                            ForEach(viewModel.sourceTiles) { tile in
                                Text(tile.text)
                                    .padding(8)
                                    .background(RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue.opacity(0.2)))
                                    .onDrag {
                                        NSItemProvider(object: tile.id.uuidString as NSString)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 200)            // <-- cap the height
                    .border(Color.gray.opacity(0.3)) // optional visual aid
                    
                    // 2) Drop trays always visible
                    // Wrap‐friendly trays grid
                    trays
                    // Optional: cap the height so it doesn’t take over the screen
                    .frame(maxHeight: 200)
                    // Win message
                    if viewModel.isWin {
                        Text("🎉 You Win!")
                            .font(.largeTitle)
                        Button("Play Again", action: viewModel.resetGame)
                            .padding(.top)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var trays: some View {
        let trayColumns = [ GridItem(.adaptive(minimum: 80)) ]
        
        ScrollView {                       // optional: only if you want vertical scrolling
            LazyVGrid(columns: trayColumns, spacing: 10) {
                ForEach(viewModel.trays.indices, id: \.self) { idx in
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 80, height: 40)
                        
                        if let tile = viewModel.trays[idx] {
                            Text(tile.text)
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.green.opacity(0.2)))
                                .onDrag {
                                    NSItemProvider(object: tile.id.uuidString as NSString)
                                }
                        }
                    }
                    .onDrop(of: [UTType.plainText], isTargeted: nil) { providers in
                        guard let provider = providers.first else { return false }
                        _ = provider.loadObject(ofClass: NSString.self) { nsStr, _ in
                            if let idString = nsStr as! String? {
                                DispatchQueue.main.async {
                                    viewModel.handleDrop(idString: idString, at: idx)
                                }
                            }
                        }
                        return true
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}



#Preview {
    MemoryTileView(currentApp: .constant(.swordMinder))
        .environmentObject(SwordMinder(player: Player(passages: [Passage(from: Reference(book: Book(rawValue: "Jeremiah")!, chapter: 9, verse: 23), to: Reference(book: Book(rawValue: "Jeremiah")!, chapter: 9, verse: 24))])))
}
