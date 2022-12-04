//
//  WordSearchAppIconView.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import SwiftUI

struct WordSearchAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.accentColor)
                Text("Word Search")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct WordSearchAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchAppIconView(action: { })
    }
}
