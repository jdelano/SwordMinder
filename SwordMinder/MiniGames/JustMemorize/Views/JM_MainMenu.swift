//
//  JM_MainMenu.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/9/22.
//

import SwiftUI

struct JM_MainMenu: View {
    /// Need this in each of your views so that you can access the sword minder view model
    /// You can of course add your own EnvironmentObjects as well to access your own view models
    @EnvironmentObject var swordMinder: SwordMinder
    //@ObservedObject var justMemorize: JustMemorize
    
    /// This is what connects your app back to the SwordMinder app. Change this binding to return to Sword Minder
    @Binding var currentApp: Apps
    
    var body: some View {
        ZStack {
            Text("Test")
            //Color("Background")
//            VStack {
//                // A basic navigation stack.
//                NavigationStack{
//                    VStack {
//                        Text("(Just Memorize Logo)")
//                            .padding()
//                            .border(.black)
//                        Spacer()
//                        Text("Just Memorize.")
//                            .font(.largeTitle)
//                        Spacer()
//                        HStack{
//                            NavigationLink("Instructions", destination: Instructions())
//                            Spacer()
//                            NavigationLink("Play", destination: JM_VersePreview())
//                            Spacer()
//                            NavigationLink("Settings", destination: Settings())
//                        }
                    }
                }
                //Spacer()
//                JM_BackToAppView()
//            }
//            .padding()
        }
//    }
//}//ContentView

// TODO
// See requirements. Ensure integration.
// Focus on functional integration first then "pretty it up."

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        JM_MainMenu(currentApp: .constant(.justMemorizeApp))
            .environmentObject(SwordMinder())
        
            //.environment(\.colorScheme, .dark)
        
        //MARK: Borders still appear white?
    }
}

//struct JM_BackToAppView: View {
//    var body: some View {
//        HStack {
//            Spacer()
//            Button("Return to SwordMinder!") {
//                withAnimation {
//                    /// To return to SwordMinder, simply set the currentApp binding back to .swordMinder
//                    currentApp = .swordMinder
//                }
//            }
//            Spacer()
//            Button("Add High Score Entry") {
//                /// To add a high score entry, use the view model's highScore function
//                ///  and pass in the name of your app, along with the user's current high score.
//                swordMinder.highScore(app: "Sample App", score: 5000)
//            }
//            Spacer()
//        }
//    }
//}
