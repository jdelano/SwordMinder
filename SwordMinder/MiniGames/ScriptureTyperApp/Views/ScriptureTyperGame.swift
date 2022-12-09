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
    @State private var showingPopover = false
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
                    showingPopover = true
                }
                .popover(isPresented: $showingPopover){
                    ScriptureTyperRules(ScriptureTyper: ScriptureTyper, currentApp: $currentApp)
                }
                Spacer()
                Text("Time")
            }.padding()
            RoundedRectangle(cornerRadius: 15).padding()
            Spacer()
            TextField("Type Verse Here", text: $typedVerse).textFieldStyle(.roundedBorder).padding()
            Spacer()
        }
    }
}
private struct DrawingConstraints {
    static let aspectRatio: CGFloat = 3/2
    static let howToPlayWidth: CGFloat = 350
    static let howToPlayHeight: CGFloat = howToPlayWidth * aspectRatio
    static let moveOnWidth: CGFloat = 100
    static let moveOnHeight: CGFloat = moveOnWidth * 0.50
}
struct ScriptureTyperGame_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperGame(ScriptureTyper: ScriptureTyper(), currentApp: .constant(.scriptureTyperApp))
            .environmentObject(SwordMinder())
    }
}
