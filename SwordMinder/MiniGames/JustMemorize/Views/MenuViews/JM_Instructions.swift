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
            Text("(Just Memorize Logo)")
                .padding()
                .border(Color("JMDarkGold"))
                .foregroundColor(Color("JMLightGold"))
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
                .padding()
                .foregroundColor(Color("JMWhite"))
            Text("Dictation and typing is coming in a future update.")
                .padding()
                .foregroundColor(Color("JMLightGold"))
            Text("Difficulties")
                .font(.title3)
                .bold()
                .padding()
                .foregroundColor(Color("JMWhite"))
            Text("Dictation / Typing")
                .font(.title3)
                .bold()
                .padding()
                .foregroundColor(Color("JMWhite"))
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
