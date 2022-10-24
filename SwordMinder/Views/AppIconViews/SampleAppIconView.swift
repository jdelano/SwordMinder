//
//  SampleAppIconView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct SampleAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.accentColor3)
                Text("Sample App")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct SampleAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        SampleAppIconView(action: { })
    }
}
