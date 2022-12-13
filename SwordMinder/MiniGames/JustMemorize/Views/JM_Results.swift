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
                    .foregroundColor(Color("JMLightGold"))
                    Spacer()
                VStack {
                    Text("Points: 200")
                        .foregroundColor(Color("JMLightGold"))
                    Text("Points Gained: 100")
                        .padding()
                        .foregroundColor(Color("JMLightGold"))
                }
            }
            .padding()
            
            Text("Accuracy: \(sampleResults)")
                .font(.largeTitle)
                .padding()
                .foregroundColor(Color("JMWhite"))
            
            Text("\(sampleReference)")
                .foregroundColor(Color("JMLightGold"))
            
            //INTERPOLATION!
            Text("\(sampleVerse1)")
                .foregroundColor(Color("JMLightGold"))
                + Text("\(sampleVerse2)")
                    .foregroundColor(.green)
            //.padding()
            //MARK: Padding here does not work
            Spacer()
            HStack {
                NavigationLink("Home", destination: JM_MainMenu(currentApp: .constant(.justMemorizeApp)))
                    .foregroundColor(Color("JMLightGold"))
                    .padding()
                Spacer()
                NavigationLink("Play Again", destination: JM_VersePreview(verseReference: Reference()))
                    .foregroundColor(Color("JMLightGold"))
                    .padding()
            }
            .frame(width: 400, height: 50)
            .border(Color("JMLightGold"))
            .padding()
        }
        .background(Color("JMBlack"))
    }//body
}

struct Results_Previews: PreviewProvider {
    static var previews: some View {
        JM_Results()
    }
}
