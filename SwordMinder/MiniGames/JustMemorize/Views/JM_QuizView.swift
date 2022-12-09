//
//  QuizView.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_QuizView: View {
    
    // Timer graciously given by Michael Smithers.
    @State private var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var sampleVerse = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, and to put on the new self, created after the likeness of God in true righteousness and holiness."
    var sampleReference = "Ephesians 4:20-24"
    
    var sampleVerseEasy = "But that __ ___ the way you ______ ______! ________ that you have heard about ___ and were taught in him, as the truth is in Jesus, to ___ off your old self, which _______ to your ______ manner of life and is _______ through deceitful ______, and to be renewed in the ______ of your minds, and to put on the ___ ____, created after the ________ of ___ in true righteousness and ________."
    
    var sampleVerseMedium = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, ___ __ ___ __ ___ ___ ____, ________ _____ ___ _________ __ ___ __ ____ ______________ ___ __________"
    
    var body: some View {
        VStack {
            HStack {
                Text("(Just Memorize Logo)")
                    Spacer()
                VStack {
                    Text("Points: 100")
                    Text("Timer: \(timeRemaining)")
                        .font(.title)
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 { timeRemaining -= 1 }
                            if timeRemaining == 0 {
                                // MARK: Help please
                                //NavigationLink(destination: JM_Results()), isActive: true)
                                
                                // I'd like to figure out a way to automatically push a new view onto the navigation stack once the timer ends but haven't quite found what I need to get this done.
                                // Ideally, the view JM_Results displays when the user either taps done at the bottom or the time runs out.
                            }
                        }
                        .padding()
                }
            }
            .padding()
            Text("\(sampleReference)")
            Text("\(sampleVerseMedium)")
                .padding()
            Spacer()
            HStack {
                Spacer()
                NavigationLink("Done", destination: JM_Results())
                    .border(.black)
            }
            .padding()
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        JM_QuizView()
    }
}
