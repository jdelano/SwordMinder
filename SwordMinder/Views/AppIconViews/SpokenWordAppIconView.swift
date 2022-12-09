//
//  SpokenWordAppIconView.swift
//  SwordMinder
//
//  Created by Logan Davis on 12/7/22.
//

import SwiftUI

struct SpokenWordAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.red)
                Text("The Spoken Word")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding()
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct SpokenWordAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        SpokenWordAppIconView(action: { })
    }
}
