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
    
    @State var isFaceUp = true
    // For How To Play
    @State private var showingPopover1 = false
    @State private var showingPopover2 = false
    // to store the user input
    @State private var typedVerse: String = ""
    
    // For Timer
    @State var timeRemaining = 120
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                Text("\(timeRemaining)")
            }.padding()
            ZStack {
                ScriptureTyperCardView(passage: passage)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
            }.padding()
            Spacer()
            HStack{
                TextField("Type Verse Here", text: $typedVerse).textFieldStyle(.roundedBorder).padding()
                Button("Submit"){
                    if typedVerse == swordMinder.bible.text(for: passage) {
                        self.timer.upstream.connect().cancel()
                    } else {
                        showingPopover2 = true
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
