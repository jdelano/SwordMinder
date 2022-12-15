//
//  QuizView.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

struct JM_QuizView: View {
    @ObservedObject var justMemorize: JustMemorize
    @EnvironmentObject var swordMinder: SwordMinder
    
    @Binding var currentView: JustMemorizeView.viewState
    
    @Binding var toggleTimer: Bool
    
    @State var textFieldText: String = ""
    
    
    // Timer graciously given by Michael Smithers.
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func timerFlipView() {
        if timeRemaining <= 0 { currentView = .results }
    }
    
    ///var sampleVerse = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, and to put on the new self, created after the likeness of God in true righteousness and holiness."
    ///var sampleReference = "Ephesians 4:20-24"
    
    ///var sampleVerseEasy = "But that __ ___ the way you ______ ______! ________ that you have heard about ___ and were taught in him, as the truth is in Jesus, to ___ off your old self, which _______ to your ______ manner of life and is _______ through deceitful ______, and to be renewed in the ______ of your minds, and to put on the ___ ____, created after the ________ of ___ in true righteousness and ________."
    
    ///var sampleVerseMedium = "But that is not the way you learned Christ! Assuming that you have heard about him and were taught in him, as the truth is in Jesus, to put off your old self, which belongs to your former manner of life and is corrupt through deceitful desires, and to be renewed in the spirit of your minds, ___ __ ___ __ ___ ___ ____, ________ _____ ___ _________ __ ___ __ ____ ______________ ___ __________"

    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Image("JMLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    Spacer()
                    VStack {
                        Text("Timer: \(timeRemaining)")
                            .font(.title)
                            .foregroundColor(Color("JMWhite"))
                            .onReceive(timer) { _ in
                                if timeRemaining > 0 { timeRemaining -= 1 }
                                ///If the timer is active and time is less than or equal to 0, the view is switched to the results view.
                                if timeRemaining <= 0 && toggleTimer == true { currentView = .results }
                            }
                            ///If the timer is active, the opacity is set to 1. If not, 0.
                            .opacity(toggleTimer == true ? 1 : 0)
                            .padding()
                    }
                }
                Text("Just Memorize.")
                    .foregroundColor(Color("JMWhite"))
                    .padding(.bottom)
                //Text("\(sampleReference)")
                    .foregroundColor(Color("JMLightGold"))
                //Text("\(sampleVerseMedium)")
                    .foregroundColor(Color("JMLightGold"))
                    .padding()
            }
            //Textfield adapted from Logan Davis's code.
            TextField("Begin typing...", text: $textFieldText, axis: .vertical)
                .lineLimit(3...)
                .padding()
                .foregroundColor(Color("JMWhite"))
                .background(Color("JMBackground").opacity(0.3).cornerRadius(10))
                .font(.headline)
            Spacer()
            Button {
                withAnimation {
                    currentView = .results
                }
            } label: {
                Text("Done")
                    .foregroundColor(Color("JMLightGold"))
            }
            .frame(width: 400, height: 50)
            .border(Color("JMLightGold"))
            .padding()
        }
        .background(Color("JMBlack"))
    }//body
}//view

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        let justMemorize = JustMemorize(difficulty: "Easy", reference: Reference(), toggleVerse: true, toggleTimer: true)
        JM_QuizView(justMemorize: justMemorize, currentView: .constant(.quizView), toggleTimer: .constant(true))
    }
}
