//
//  SampleAppIconView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct AppIconView: View {
    let title: String
    let iconImageName: String
    let action: () -> Void
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Image(iconImageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 40.0))
            }
            Text(title)
        }
    }
}

#Preview {
    AppIconView(title: "Memory Tile", iconImageName: "MemoryTileIcon", action: { })
}
