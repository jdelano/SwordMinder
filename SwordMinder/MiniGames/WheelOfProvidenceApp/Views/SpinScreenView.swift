//
//  SpinScreenView.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import SwiftUI

struct SpinScreenView: View {
    var body: some View {
        VStack{
            Spacer()
            WheelView()
            Button("Spin!", action: {
                
            })
        }
    }
}

struct SpinScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SpinScreenView()
    }
}
