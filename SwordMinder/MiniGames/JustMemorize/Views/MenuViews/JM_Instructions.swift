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
                        .padding(.top)
                        .foregroundColor(Color("JMLightGold"))
                    Text("  Tap the grey text box when you are ready, and then either type the verse in or speak it aloud.")
                        .padding()
                        .foregroundColor(Color("JMLightGold"))
                    Text("Difficulties")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color("JMWhite"))
                    Text("  Difficulties come in three flavors: easy, medium, and hard. In easy difficulty, 15% of the words will be missing. In medium difficulty, half the words will be missing.")
                        .padding(.horizontal)
                        .foregroundColor(Color("JMLightGold"))
                    Text("In hard difficulty, no hints will be given.")
                        .padding(.top)
                        .foregroundColor(Color("JMLightGold"))
                    Text("Verses")
                        .font(.title3)
                        .bold()
                        .padding(.top)
                        .foregroundColor(Color("JMWhite"))
                    Text("  Verses inputted into Swordminder's Memorize tab, on the home screen, will appear Just Memorize. The verse preview is optional, in case you want a reminder or if you prefer to go right into memorizing.")
                        .padding(.horizontal)
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
