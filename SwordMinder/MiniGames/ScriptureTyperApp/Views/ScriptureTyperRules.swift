//
//  ScriptureTyperRules.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/7/22.
//

import SwiftUI

struct ScriptureTyperRules: View {
    @ObservedObject var ScriptureTyper: ScriptureTyper
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    var body: some View {
            VStack {
                Spacer()
                howToPlay
                Spacer()
                HStack {
                    moveOn
                    Button {
                        currentApp = .swordMinder
                    } label: {
                        Text("Return to Sword Minder")
                    }
                }
                Spacer()
            }
            .padding()
        }
    ///When the mini-game is tapped on the home screen of Sword Minder, a “How to play” list will appear with a continue button
    var howToPlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.teal)
                .frame(width: DrawingConstraints.howToPlayWidth, height: DrawingConstraints.howToPlayHeight)
            VStack(alignment: .center) {
                Spacer()
                Text("RULES OF PLAY").font(.largeTitle).multilineTextAlignment(.leading)
                Spacer()
                Text(" - In the next screen, choose a verse to practice")
                    .font(.subheadline)
                Text(" - After a verse has been selected, Memorize the verse")
                    .font(.subheadline)
                Text(" - Flip the Verse Card to Begin Typing")
                    .font(.subheadline)
                Text(" - When you are Finished Typing Tap Submit to Stop the Clock")
                    .font(.subheadline)
                Spacer()
            }
            .padding()
            .frame(width: DrawingConstraints.howToPlayWidth, height: DrawingConstraints.howToPlayHeight)
            
            
        }
    }
    
    var moveOn: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.green)
                .frame(width: DrawingConstraints.moveOnWidth, height: DrawingConstraints.moveOnHeight)
//            NavigationLink(destination: ScriptureTyperGame()) { Text("Continue")
//                .foregroundColor(Color.black)}
        }
    }
    
    private struct DrawingConstraints {
        static let aspectRatio: CGFloat = 3/2
        static let howToPlayWidth: CGFloat = 350
        static let howToPlayHeight: CGFloat = howToPlayWidth * aspectRatio
        static let moveOnWidth: CGFloat = 100
        static let moveOnHeight: CGFloat = moveOnWidth * 0.50
        
    }
}

struct ScriptureTyperRules_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperRules(ScriptureTyper: ScriptureTyper(), currentApp: .constant(.scriptureTyperApp))
            .environmentObject(SwordMinder())
    }
}
