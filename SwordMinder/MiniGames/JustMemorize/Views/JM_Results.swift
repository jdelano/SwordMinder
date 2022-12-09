//
//  Results.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_Results: View {
    
    var sampleResults = "80%"
    
    var sampleVerse1 = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, "
    var sampleReference = "Ephesians 4:20-24"
    
    var sampleVerse2 = "and to put on the new self, created after the likeness of God in true righteousness and holiness."
    
    var sampleVerseBlanks = "But that __ ___ the way you ______ ______! ________ that you have heard about ___ and were taught in him, as the truth is in Jesus, to ___ off your old self, which _______ to your ______ manner of life and is _______ through deceitful ______, and to be renewed in the ______ of your minds, and to put on the ___ ____, created after the ________ of ___ in true righteousness and ________."
    
    var body: some View {
        VStack {
            HStack {
                Text("(Just Memorize Logo)")
                    Spacer()
                VStack {
                    Text("Points: 200")
                    Text("Points Gained: 100")
                        .padding()
                }
            }
            .padding()
            
            Text("Accuracy: \(sampleResults)")
                .font(.largeTitle)
                .padding()
            
            Text("\(sampleReference)")
            
            //INTERPOLATION!
            Text("\(sampleVerse1)")
                .foregroundColor(.black)
                + Text("\(sampleVerse2)")
                    .foregroundColor(.green)
            //.padding()
            //MARK: Padding here does not work
            Spacer()
            HStack {
                NavigationLink("Home", destination: JM_MainMenu())
                Spacer()
                NavigationLink("Play Again", destination: JM_VersePreview())
            }
            //.frame(width: 200, height: 20)
            .border(.black)
            .padding()
        }
    }
}

struct Results_Previews: PreviewProvider {
    static var previews: some View {
        JM_Results()
    }
}
