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
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.accentColor)
                Image("logo")
                    .resizable()
                    .frame(maxWidth: 250, maxHeight: 200)
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

