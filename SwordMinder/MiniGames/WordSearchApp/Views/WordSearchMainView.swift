//
//  WordSearchMainView.swift
//  SwordMinder
//
//  Created by John Delano on 2/3/23.
//

import SwiftUI

struct WordSearchMainView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @StateObject private var wordSearch: WordSearch = WordSearch()
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
                            HStack {
                                Text(.init(passage.referenceFormatted))
                                Spacer()
                                Image(systemName: swordMinder.isPassageReviewedToday(passage) ? "checkmark" : "")
                                    .foregroundColor(.green)
                            }
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
                    WordSearchSettingsView(difficulty: $wordSearch.difficulty)
                }
            }
        }
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




struct WordSearchMainView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchMainView(currentApp: .constant(.wordSearchApp))
            .environmentObject(SwordMinder(player: Player(passages: [Passage(), Passage(fromString: "John 3:16")!])))
    }
}
