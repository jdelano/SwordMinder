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
            ZStack {
                ScriptureTyperCardView(passage: passage)
                    .onTapGesture {
                        isFaceUp = false
                    }
            }.padding()
            Spacer()
            HStack{
                TextField("Type Verse Here", text: $typedVerse).textFieldStyle(.roundedBorder).padding()
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
                        Text("Congratulations").foregroundColor(.white)
                    }
                }
                .popover(isPresented: $showingPopover2){
                    ZStack{
                        RoundedRectangle(cornerRadius: 25).foregroundColor(.red)
                        Text("TRY AGAIN").foregroundColor(.white)
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
