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
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.teal)
                .frame(width: DrawingConstraints.howToPlayWidth, height: DrawingConstraints.howToPlayHeight)
            VStack {
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
