//
//  ScriptureTyperGame.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/7/22.
//

import SwiftUI

struct ScriptureTyperGame: View {
    @ObservedObject var ScriptureTyper: ScriptureTyper
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    var passage: Passage
    let letters = " ABCDEFGHIJKLMNOPQRSTUVWXYZ,.;:'!"
    @State var isFaceUp = true
    //Popovers
    @State private var showingPopover1 = false
    @State private var showingPopover2 = false
    @State private var showingPopover3 = false
    // to store the user input
    @State private var typedVerse: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    withAnimation {
                        currentApp = .swordMinder
                    }
                } label:{
                    Image(systemName: "house")
                }
                Spacer()
                Button("How to Play"){
                    showingPopover1 = true
                }
                .popover(isPresented: $showingPopover1){
                    ScriptureTyperRules(ScriptureTyper: ScriptureTyper, currentApp: $currentApp)
                }
                Spacer()
                Text(String(ScriptureTyper.secondsElapsed))
            }.padding()
            ScriptureTyperCardView(passage: passage).padding()
                .onTapGesture {
                    ScriptureTyper.start()
                }
            Spacer()
            HStack{
                TextField("Type Verse Here", text: $typedVerse, axis: .vertical).textFieldStyle(.roundedBorder).padding()
                Button("Submit"){
                    if typedVerse.uppercased() == swordMinder.bible.text(for: passage).uppercased().filter({letters.contains($0)}) {
                        swordMinder.completeTask(difficulty: 3)
                        ScriptureTyper.stop()
                        showingPopover3 = true
                    } else if typedVerse != swordMinder.bible.text(for: passage).uppercased().filter({letters.contains($0)}){
                        showingPopover2 = true
                    }
                }
                .popover(isPresented: $showingPopover3){
                    ZStack{
                        RoundedRectangle(cornerRadius: 25).foregroundColor(.green)
                        VStack{
                            Spacer()
                            Button {
                                withAnimation {
                                    currentApp = .swordMinder
                                }
                            } label:{
                                Text("Return to Sword Minder")
                            }
                            Spacer()
                            Text("Congratulations").foregroundColor(.white)
                            Text("You've earned 3 gems").foregroundColor(.white)
                            Spacer()
                        }
                        
                    }
                }
                .popover(isPresented: $showingPopover2){
                    ZStack{
                        RoundedRectangle(cornerRadius: 25).foregroundColor(.red)
                        VStack{
                            Text("To return to game, swipe down")
                            Spacer()
                            Text("TRY AGAIN").foregroundColor(.white)
                            Spacer()
                        }
                        
                    }
                }
                .padding()
                .background(Color(red:0, green: 2, blue: 1))
                .clipShape(Capsule())
            }.padding()
            Spacer()
        }
    }
    
    
}
private struct DrawingConstraints {
    static let aspectRatio: CGFloat = 3/2
}
struct ScriptureTyperGame_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperGame(ScriptureTyper: ScriptureTyper(), currentApp: .constant(.scriptureTyperApp), passage: Passage())
            .environmentObject(SwordMinder())
    }
}
