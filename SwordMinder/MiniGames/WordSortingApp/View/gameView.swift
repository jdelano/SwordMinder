//
//  gameView.swift
//  SwordMinder
//
//  Created by Caleb Kowalewski on 12/12/22.
//


import SwiftUI
struct gameView: View{
    @State var passage: Passage
    @State var verseReference: Reference
    @EnvironmentObject var swordMinder: SwordMinder
    @State var X = 0
    //word for verse which is blank
    @State private var wordFromVerse = ""
    @FocusState var isInputActive: Bool
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Image("star")
                    .resizable()
                   .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 8){
                    
                    HStack{
                        Spacer()
                        Text(passage.referenceFormatted)
                        Spacer()
                        score
                        Spacer()
                        
                    }
                    .font(.title2)
                    .foregroundColor(.white).bold()
                  Spacer()
                    VerseTappingView(verseReference: Reference())
                }
            }
            
        }
    }
}

struct VersesView: View{
    var word: String
        var body: some View{
            ZStack{
                RoundedRectangle(cornerRadius:20)
                    .foregroundColor(.blue)
                HStack {
                    Text(word)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }
            }
        }
    }

 var score: some View{
    //score for player will be calculated here once the game is operational
     // will use the score variable once
     Text("Score: 100").foregroundColor(.white)
   
}

struct gameView_Previews: PreviewProvider{
    static var previews: some View{
        gameView(passage: Passage(), verseReference: Reference()).environmentObject(SwordMinder())
    }
}
