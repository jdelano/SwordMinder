//
//  ScriptureTyperGame.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/7/22.
//

import SwiftUI

struct ScriptureTyperGame: View {
    @ObservedObject var ScriptureTyper: ScriptureTyper
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    
    @State private var typedVerse: String = ""
    @State private var isFaceDown: Bool = false
    @State private var verse: String = "Jesus wept"
    @State private var isMatched: Bool = false
    @State private var progressTime: Int = 120
    @State private var isRunning: Bool = false
    //@State private var retry: Bool = false
    //Requirements:
    ///When the start button is tapped, a view will appear with a textbox and an on-screen keyboard.  - This has been redesigned to always show
    ///When the start button is pressed a timer will appear counting the time it takes for the user to complete the verse. - The button has been replaced with the tapping the card
    ///When the user completes the last word of the verse, the timer will stop, and the time will be displayed. - The user has to tap the "check" button to verify the verse is correct
    //These two requirements have not been implemented -- decided to have this happen in the background
    ///When the final time is displayed, that time will be used to determine the amount of in-game currency that is rewarded to the user.
    ///When the final time is displayed by, there will be a button that will allow the user to go back to the main page of the mini-game.
    
    
    var body: some View {
        NavigationView {
            stopWatch
            Spacer()
            verseCard
            Spacer()
            textBox
            Spacer()
        }
    }
    var stopWatch: some View {
        HStack {
            Spacer()
            Text("\(minutes):\(seconds)")
                .padding()
                .font(.title2)
        }
    }
    
    var verseCard: some View {
        ZStack{
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstraints.cardRadius)
            if isFaceDown == false {
                cardShape.fill(.white)
                cardShape.strokeBorder(lineWidth: 3)
                Text(verse)
                    .font(.largeTitle)
            } else{
                cardShape.fill(.purple)
            }
        }
        .onTapGesture {
            withAnimation(){
                isFaceDown.toggle()
            }
            isRunning = true
            startTimer()
            
        }
        .padding()
        
    }
    
    var textBox: some View {
        VStack {
            Spacer()
            HStack {
                Text("Pass: \(isMatched ? "Yes!" : "No!")")
                Text( isMatched ? "👍":"👎")
            }
            HStack {
                TextField("type verse here", text: $typedVerse, axis: .vertical).padding(.leading).multilineTextAlignment(.leading).lineLimit(1...5)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                check
            }.padding()
            Spacer()
        }
    }
    
    var check: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.teal)
            Text("Check")
        }
        .frame(width: DrawingConstraints.checkWidth, height: DrawingConstraints.checkHeight)
        .onTapGesture {
            Matching()
        }
    }
    
    //possibly replace timer with : https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
    
    
    var minutes: Int {
        (progressTime % 3600) / 60
    }
    
    var seconds: Int {
        progressTime % 60
    }
    func Matching(){
        if (typedVerse == verse) && (isFaceDown == true) {
            isMatched = true
            stopTimer()
        } else {
            isMatched = false
        }
    }
    func startTimer() {
        if isRunning {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: (isRunning ? true : false)) {_ in
                progressTime -= 1
            }
        } else {
            progressTime = progressTime
        }
        
    }
    func stopTimer() {
        isRunning = false
    }
    func restartTimer() {
        progressTime = 120
    }
}

private struct DrawingConstraints {
    static let cardRadius: CGFloat = 25
    static let aspectRatio: CGFloat = 2/3
    static let textBoxHeight: CGFloat = 5
    static let textBoxWidth: CGFloat = 250
    static let verseCardWidth: CGFloat = 250
    static let verseCardHeight: CGFloat = verseCardWidth * aspectRatio
    static let checkWidth: CGFloat = 60
    static let checkHeight: CGFloat = checkWidth * aspectRatio
}

struct ScriptureTyperGame_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperGame(ScriptureTyper: ScriptureTyper(), currentApp: .constant(.scriptureTyperApp))
            .environmentObject(SwordMinder())
    }
}
