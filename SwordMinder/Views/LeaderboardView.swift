//
//  LeaderboardView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var swordMinder: SwordMinder
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Leaderboard")
                .font(.largeTitle)
            List(swordMinder.highScoreEntries) { entry in
                HStack {
                    Text("\(entry.app)")
                    Spacer()
                    Text("\(entry.score)")
                }
            }
        }
        .padding()
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(swordMinder: SwordMinder(leaderboard: Leaderboard(entries: [
            SwordMinder.Entry(app:"Bible Trivia", score: 500),
            SwordMinder.Entry(app:"Bible Tetris", score: 1000),
            SwordMinder.Entry(app:"Speak'n'Say", score: 1500),
            SwordMinder.Entry(app:"Talk it Out", score: 250),
            SwordMinder.Entry(app:"Block Book", score: 100)
        ])))
    }
}
