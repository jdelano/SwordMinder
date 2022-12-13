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
            /// This image currently does not fit aspect ratios.
            //Image("JMLogo")
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("JMBlack"))
                Text("JustMemorize")
                    .foregroundColor(Color("JMLightGold"))
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }// this curly brace is unneeded when using image
            }
            .aspectRatio(1, contentMode: .fit)
    }
}

struct JustMemorizeAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        JustMemorizeAppIconView(action: { })
    }
}
