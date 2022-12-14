//
//  Instructions.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

// This will later serve as the menu where the user selects verses fromt he swordminder API.
struct JM_Instructions: View {
    var body: some View {
        VStack {
            Image("JMLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .padding(.bottom)
            Text("Instructions")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color("JMWhite"))
            Text("Just press play, and memorize.")
                .padding()
                .foregroundColor(Color("JMLightGold"))
            Text("Dictation / Typing")
                .font(.title3)
                .bold()
                .padding(.top)
                .foregroundColor(Color("JMWhite"))
            Text("Dictation and typing is coming in a future update.")
                .padding()
                .foregroundColor(Color("JMLightGold"))
            Text("Difficulties")
                .font(.title3)
                .bold()
                .padding(.top)
                .foregroundColor(Color("JMWhite"))
            Text("Difficulties are coming in a future update.")
                .padding()
                .foregroundColor(Color("JMLightGold"))
            Text("Verse Preivew")
                .font(.title3)
                .bold()
                .padding(.top)
                .foregroundColor(Color("JMWhite"))
            Text("The adjustable preview is coming in a future update.")
                .padding()
                .foregroundColor(Color("JMLightGold"))
        }
        .frame(maxWidth: 100000, maxHeight: 100000)
        .background(Color("JMBlack"))
    }
}

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        JM_Instructions()
    }
}
