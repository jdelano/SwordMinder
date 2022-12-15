//
//  Instructions.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_Instructions: View {
    @Binding var currentView: JustMemorizeView.viewState
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                currentView = .mainMenu
                            }
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                Text("Main Menu")
                            }
                        }
                        .foregroundColor(Color("JMLightGold"))
                        .padding(.leading)
                        Spacer()
                    } //HStack
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
                }//Vstack
                .frame(maxWidth: 100000, maxHeight: 100000)
                .background(Color("JMBlack"))
            }//ScrollView
            .background(Color("JMBlack"))
        }
    }//Body
}//Struct

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        JM_Instructions(currentView: .constant(.instructions))
    }
}
