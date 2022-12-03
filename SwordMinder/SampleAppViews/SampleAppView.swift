//
//  SampleAppView.swift
//  SwordMinder
//
//  Created by John Delano on 10/21/22.
//

import SwiftUI

struct SampleAppView: View {
    /// Need this in each of your views so that you can access the sword minder view model
    /// You can of course add your own EnvironmentObjects as well to access your own view models
    @EnvironmentObject var swordMinder: SwordMinder
    
    /// This is what connects your app back to the SwordMinder app. Change this binding to return to Sword Minder
    @Binding var currentApp: Apps
    
    var body: some View {
        VStack {
            Spacer()
            Button("Return to SwordMinder!") {
                withAnimation {
                    /// To return to SwordMinder, simply set the currentApp binding back to .swordMinder
                    currentApp = .swordMinder
                }
            }
            Spacer()
            Button("Add High Score Entry") {
                /// To add a high score entry, use the view model's highScore function
                ///  and pass in the name of your app, along with the user's current high score.
                swordMinder.highScore(app: "Sample App", score: 5000)
            }
            Spacer()
        }
    }
}

struct SampleApp_Previews: PreviewProvider {
    static var previews: some View {
        SampleAppView(currentApp: .constant(.sampleApp))
            .environmentObject(SwordMinder())
    }
}
