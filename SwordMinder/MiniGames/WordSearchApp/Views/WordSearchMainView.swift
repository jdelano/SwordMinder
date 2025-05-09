//
//  WordSearchMainView.swift
//  SwordMinder
//
//  Created by John Delano on 2/3/23.
//

import SwiftUI

struct WordSearchMainView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @StateObject private var wordSearch: WordSearchGame = WordSearchGame()
    @State private var settingsShown: Bool = false
    @Binding var currentApp: Apps
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    ForEach(swordMinder.passages) { passage in
                        NavigationLink {
                            WordSearchGridView(wordSearch: wordSearch, passage: passage)
                        } label: {
                            Text(.init(passage.referenceFormatted))
                        }
                    }
                    HStack(alignment: .bottom) {
                        Spacer()
                        Text("Difficulty Level: \(wordSearch.difficulty.rawValue)")
                        Spacer()
                    }
                    .padding(.top)
                }
                .toolbar { toolbar }
                .navigationTitle("Select a Passage")
                .sheet(isPresented: $settingsShown, onDismiss: { settingsShown = false }) {
                    WordSearchSettingsView(settings: $wordSearch.game)
                }
            }
        }
        .overlay(wordSearch.showTutorial ? TutorialView(showTutorial: $wordSearch.showTutorial) : nil)
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                currentApp = .swordMinder
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Return to SwordMinder")
                }
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { settingsShown = true }) {
                Image(systemName: "gear")
                    .padding(5)
            }
        }
    }
    
}




#Preview {
    WordSearchMainView(currentApp: .constant(.wordSearchApp))
        .environmentObject(SwordMinder(player: Player(passages: [Passage(), Passage(fromString: "John 3:16")!])))
    
}
