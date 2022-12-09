//
//  Game.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_VersePreview: View {
    
    // Timer graciously given by Michael Smithers.
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var sampleVerse = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, and to put on the new self, created after the likeness of God in true righteousness and holiness."
    var sampleReference = "Ephesians 4:20-24"
    
    var body: some View {
        // Give the lazy v-grid a go.
        VStack {
            //Title and points
            HStack {
                Text("(Just Memorize Logo)")
                    Spacer()
                Text("Points: 100")
                    .padding()
            }
            .padding(.leading)
            
            //Body
            Text("VERSE PREVIEW")
                .font(.headline)
            .padding()
            Text("\(sampleReference)")
            Text("\(sampleVerse)")
                .padding()
            Spacer()
            HStack {
                NavigationLink("Instructions", destination: Instructions())
                Spacer()
                NavigationLink("Start", destination: JM_QuizView())
            }
            .padding()
        }
    }
}

struct Game_Previews: PreviewProvider {
    static var previews: some View {
        JM_VersePreview()
    }
}
