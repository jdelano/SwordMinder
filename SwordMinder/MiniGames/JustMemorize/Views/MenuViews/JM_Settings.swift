//
//  Settings.swift
//  JustMemorize
//
//  Created by Jared Waltz on 12/5/22.
//

import SwiftUI

//Note that due to textfields using both dictation and typing, an optional input picker is unnecessary.

struct JM_Settings: View {
    @ObservedObject var justMemorize: JustMemorize
    @Binding var currentView: JustMemorizeView.viewState
    
    @Binding var currentApp: Apps
    
    // Consider a scroll view if necessary.
    var body: some View {
        ZStack {
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
                }
                VStack{
                    Image("JMLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding()
                    // Difficulty Selection
                    Text("Difficulty")
                        .foregroundColor(Color("JMLightGold"))
                    Picker ("Difficulty Picker", selection: $justMemorize.selectedDifficulty) {
                        ForEach($justMemorize.difficulties.wrappedValue, id: \.self) {
                            Text($0)
                        }
                        .foregroundColor(Color("JMLightGold"))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Current Difficulty: \($justMemorize.selectedDifficulty.wrappedValue)")
                        .foregroundColor(Color("JMLightGold"))
                        .padding(.bottom)
                    //Input Type
//                    Text("Input Type:")
//                        .foregroundColor(Color("JMLightGold"))
//                    Picker ("Input Picker", selection: $justMemorize.selectedInput) {
//                        ForEach($justMemorize.inputTypes.wrappedValue, id: \.self) {
//                            Text($0)
//                        }
//                        .foregroundColor(Color("JMLightGold"))
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    Text("Current Input: \($justMemorize.selectedInput.wrappedValue)")
//                        .foregroundColor(Color("JMLightGold"))
//                    Spacer()
                }
                
                Spacer()
                Button("Tap to view your Memorization List") {
                    withAnimation {
                        currentView = .passageView
                    }
                }
                .frame(width: 400, height: 80)
                .border(Color("JMDarkGold"))
                .foregroundColor(Color("JMLightGold"))
                Spacer()
                
                // Show verse?
                HStack {
                    Toggle(isOn: $justMemorize.toggleVerse) {
                        Text("Show Verse Preview")
                            .foregroundColor(Color("JMLightGold"))
//                        Text("Show Verse Preview: \(String(toggleVerse))")
//                            .foregroundColor(Color("JMLightGold"))
                    }
                    .tint(Color("JMLightGold"))
                    .padding()
                Spacer()
                }
                //Show timer?
                HStack {
                    Toggle(isOn: $justMemorize.toggleTimer) {
                        Text("Show Timer")
                            .foregroundColor(Color("JMLightGold"))
                    }
                    .tint(Color("JMLightGold"))
                    .padding()
                Spacer()
                }
                Spacer()
                .background(Color("JMBlack"))
            }
            .background(Color("JMBlack"))
        }//zstack
        .frame(maxWidth: 100000, maxHeight: 100000)
        .background(Color("JMBlack"))
    }//Body
}//Settings Struct

// It may be easier to not have this but I keep getting errors in button. It also serves as a good placeholder for later.
private func nothing() {
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let justMemorize = JustMemorize(difficulty: "Easy", reference: Reference(), toggleVerse: true, toggleTimer: true, score: 0)
        JM_Settings(justMemorize: justMemorize, currentView: .constant(.settings), currentApp: .constant(.justMemorizeApp))
    }
}
