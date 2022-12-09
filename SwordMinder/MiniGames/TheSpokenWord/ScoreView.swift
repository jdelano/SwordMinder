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
                    Text("For God so loved the world that he forgot the rest of the words to the verse") //will be the text submitted inside of DictationView
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
                Text("You scored a:")
                    .font(.largeTitle)
                Text("80%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                // if a score of 80 or below is given, the text is red and the next verse option will be grayed out
                // this score will use a multiplier to add points to the player
            }
            VStack {
                Button {
                } label: {
                    Text("Try Again")
                        .frame(height:55)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(10)
                Button {
                } label: {
                    Text("Next Verse")
                        .frame(height:55)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(10)
                // this next verse button will add the verse to the completed verse list per the requirements list
            }
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(reference: Reference(book: Book(named: "John")!, chapter: 3, verse: 16), answer: "For God so loved the world.").preferredColorScheme(.light)
            .environmentObject(SwordMinder())
//        ScoreView().preferredColorScheme(.dark)
    }
}
