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
            List {
                Text("Memorize the verse")
                    .font(.subheadline)
                Text("After you have memorized the verse, flip the verse card over")
                    .font(.subheadline)
                Text("The time will not start until the verse card us flipped")
                    .font(.subheadline)
                Text("When you are finished typing tap submit to stop the clock")
                    .font(.subheadline)
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
