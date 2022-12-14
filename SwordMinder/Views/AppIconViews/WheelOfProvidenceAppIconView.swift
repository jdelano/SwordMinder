//
//  WheelOfProvidenceAppIconView.swift
//  SwordMinder
//
//  Created by user226647 on 12/14/22.
//

import SwiftUI

struct WheelOfProvidenceAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.accentColor)
                WheelView(pieWheel: PieWheel(text1: "", text2: "", text3: "", text4: "", isSpun: false))
                VStack{
                    Text("Wheel")
                    Text("Of")
                    Text("Providence")
                }
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct WheelOfProvidenceAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        WheelOfProvidenceAppIconView(action: { })
    }
}
