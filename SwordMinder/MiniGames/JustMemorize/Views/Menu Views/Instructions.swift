//
//  Instructions.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

// This will later serve as the menu where the user selects verses fromt he swordminder API.
struct Instructions: View {
    var body: some View {
        VStack {
            Text("(Just Memorize Logo)")
                .padding()
                .border(.black)
            Text("Instructions")
                .font(.largeTitle)
                .bold()
                .padding()
            Text("Dictation / Typing")
                .font(.title3)
                .bold()
                .padding()
            Text("Difficulties")
                .font(.title3)
                .bold()
                .padding()
            Text("Dictation / Typing")
                .font(.title3)
                .bold()
                .padding()
        }
    }
}

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        Instructions()
    }
}
