//
//  SMButtonView.swift
//  SwordMinder
//
//  Created by John Delano on 9/28/22.
//

import SwiftUI

struct SMButtonView: View {
    @Environment(\.isEnabled) private var isEnabled
    var title: String = ""
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
        }
        .buttonStyle(SMButtonStyle())
    }
}



#Preview {
    SMButtonView(title: "Level Up") {
    }
    
    SMButtonView(title: "Level Up") {
    }
    .disabled(true)
}
