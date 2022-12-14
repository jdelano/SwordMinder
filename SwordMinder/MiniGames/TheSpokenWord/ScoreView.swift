//
//  VerseView3.swift
//  TheSpokenWord
//
//  Created by Logan Davis on 11/1/22.
//
// I removed requirement 7, as it was an unnececarily complex part of the game that didnt add any real functionality to it.

import Foundation

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    var reference: Reference
    var answer: String
    
    
   
    var body: some View {
       
        VStack{
            ZStack (alignment: .top) {
                VStack {
                    Text(reference.toString()) //will be one of the objects in the array of verses
                        .font(.largeTitle)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                        )
                }
            }
            ZStack {
                RoundedRectangle (cornerRadius: 5).stroke(.gray, lineWidth: 1)
                VStack {
                    Text("Your Spoken Word:")
                        .font(.title2)
                    Spacer()
                    Text(answer)
                    Spacer()
                }.padding()
            }.padding(8)
            ZStack {
                RoundedRectangle (cornerRadius: 5).stroke(.gray, lineWidth: 1)
                VStack {
                    Text("Actual Text:")
                        .font(.title2)
                    Spacer()
                    Text(swordMinder.bible.text(for: reference)) //will be the text from the actual verse
                    Spacer()
                }.padding()
            }.padding(8)
            HStack{
                Text("You scored:")
                    .font(.largeTitle)
                let alpha = "QWERTYUIOPASDFGHJKLZXCVBNM"
                let verse = swordMinder.bible.text(for: Reference())
                let cleanedText = verse.uppercased().filter {
                    alpha.contains($0)
                }
                Text(String(format: "%.0f", (cleanedText.distanceJaroWinkler(between: answer)*100)))
                //                Text("\(swordMinder.bible.text(for: reference).distanceJaroWinkler(between: answer)*100)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                // if a score of 80 or below is given, the text is red and the next verse option will be grayed out
                // this score will use a multiplier to add points to the player
            }
            VStack {
                ScoreSet(setTitle: "Try Again", buttonColor: "#CB4C4E"){
                    DictationView(reference: reference)
                }
                ScoreSet(setTitle:"Next Verse", buttonColor: "#2F3148") {
                    if let ref = swordMinder.bible.randomReference(matching: reference.toString().filter("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM".contains)) {
                        DictationView(reference: ref)
                    }
                    
                    //                Button {
                    //                } label: {
                    //                    Text("Next Verse")
                    //                        .frame(height:55)
                    //                        .frame(maxWidth: .infinity)
                    //                }
                    //                .buttonStyle(.borderedProminent)
                    //                .padding(10)
                    //                .tint(Color("#2F3148"))
                    // this next verse button will add the verse to the completed verse list per the requirements list
                }
            }
        }
    }
    
    struct BackSet<Destination : View>: View {
        var setTitle: String
        var buttonColor: String
        var destination: Destination
        
        init(setTitle: String, buttonColor: String, @ViewBuilder destination: () -> Destination) {
            self.setTitle = setTitle
            self.buttonColor = buttonColor
            self.destination = destination()
        }
        
        var body: some View{
            NavigationLink {
                destination
            } label: {
                Text(setTitle)
                    .frame(height:55)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(buttonColor))
            .padding(10)
        }
    }
    
    
    struct ScoreView_Previews: PreviewProvider {
        static var previews: some View {
            ScoreView(reference: Reference(book: Book(named: "John")!, chapter: 3, verse: 16), answer: "For God so loved the world.").preferredColorScheme(.light)
                .environmentObject(SwordMinder())
            //        ScoreView().preferredColorScheme(.dark)
        }
    }
}
