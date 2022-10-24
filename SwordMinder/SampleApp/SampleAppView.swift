//
//  SampleAppView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct SampleAppView: View {
    @Binding var currentApp: Apps
    
    var body: some View {
        Button {
            withAnimation {
                currentApp = .swordMinder
            }
        } label: {
            Text("Return to SwordMinder!")
        }
    }
}

struct SampleApp_Previews: PreviewProvider {
    static var previews: some View {
        SampleAppView(currentApp: .constant(.sampleApp))
    }
}
