//
//  FlappyMemoryAppIconView.swift
//  SwordMinder
//
//  Created by Michael Smithers on 12/11/22.
//

import SwiftUI

struct FlappyMemoryAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                Image("logo")
                    .resizable()
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color.accentColor3)
//                Text("Flappy Memory")
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct FlappyMemoryAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        FlappyMemoryAppIconView(action: { })
    }
}

