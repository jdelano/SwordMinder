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
    
    // For How To Play
    @State private var showingPopover = false
    
    // to store the user input
    @State private var typedVerse: String = ""
    
    // For Timer
    @State var timeRemaining = 120
    @State var isTimerRunning = false
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
                    showingPopover = true
                }
                .popover(isPresented: $showingPopover){
                    ScriptureTyperRules(ScriptureTyper: ScriptureTyper, currentApp: $currentApp)
                }
                Spacer()
                Text("\(timeRemaining)")
                    .onReceive(timer) { _ in
                        if isTimerRunning {
                            timeRemaining -= 1
                        }
                    }
                    .onAppear() {
                        isTimerRunning = false
                    }
            }.padding()
            ZStack {
                ScriptureTyperCardView(isFaceUp: true, verseReference: "lol: 233", verse: "lol")
                    .onTapGesture {
                        isTimerRunning.toggle()
                    }
            }.padding()
            Spacer()
            TextField("Type Verse Here", text: $typedVerse).textFieldStyle(.roundedBorder).padding()
            Spacer()
        }
    }
    
    
}
private struct DrawingConstraints {
    static let aspectRatio: CGFloat = 3/2
}
struct ScriptureTyperGame_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperGame(ScriptureTyper: ScriptureTyper(), currentApp: .constant(.scriptureTyperApp))
            .environmentObject(SwordMinder())
    }
}
