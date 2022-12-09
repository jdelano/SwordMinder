//
//  ScriptureTyperAppIconView.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/8/22.
//

import SwiftUI

struct ScriptureTyperAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cyan)
                Text("Scripture Typer")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .hoverEffect(/*@START_MENU_TOKEN@*/.lift/*@END_MENU_TOKEN@*/)
                    .rotationEffect(.degrees(-45))
                
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct ScriptureTyperAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperAppIconView(action: { })
    }
}
