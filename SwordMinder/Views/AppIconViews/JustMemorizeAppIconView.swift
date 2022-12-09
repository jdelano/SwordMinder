//
//  JustMemorizeAppIconView.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/8/22.
//

import SwiftUI

struct JustMemorizeAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black)
                Text("JustMemorize")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct JustMemorizeAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        JustMemorizeAppIconView(action: { })
    }
}
