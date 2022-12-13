//
//  FlappyMemoryView.swift
//  Flappy Bird
//
//  Created by Michael Smithers on 12/11/22.
//

import SpriteKit
import SwiftUI

//View for the SpriteKit
struct FlappyMemoryView: View {
    @ObservedObject var game: GameScene
    @Binding var currentApp: Apps
    @State private var timeRemaining = 45
    @State var gamePassed = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var scene: SKScene {
        let scene = game
        scene.size = CGSize(width: 400, height: 700)
        scene.scaleMode = .fill
        return scene
    }


    var body: some View {
        
        if timeRemaining == 0 || game.gameState == GameState.dead{
            gameFail
                .ignoresSafeArea()
        }
        else if timeRemaining > 0 && gamePassed == false {
            gameBody
        }
        else if timeRemaining > 0 && gamePassed == true {
            win
                .ignoresSafeArea()
        }

    }
    
    var gameBody: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: 400, height: 700)
            VStack {
                
                HStack {
                    Spacer()
                    time
                }
                Spacer()
            }
        }
    }
    
    var win: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .foregroundColor(.white)
            VStack {
                Text("Pass")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                Text("+300 Gems")
                    .font(.headline)
                
                Button("Return to SwordMinder") {
                    //This will have  the code to return to the main game
                    withAnimation {
                        currentApp = .swordMinder
                    }
                }
            }
        }
    }
    
    var gameFail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .foregroundColor(.black)
            VStack {
                Text("Game Over")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                .foregroundColor(.red)
                Button("Return to SwordMinder") {
                    //This will have  the code to return to the main game
                    withAnimation {
                        currentApp = .swordMinder
                    }
                }
            }
        }
    }
    
    var time: some View {
        Text("\(timeRemaining)")
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            .font(.title)
            .padding()
            .foregroundColor(.black)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 0
        
    }
}

struct SpriteView_Previews: PreviewProvider {
    static var previews: some View {
        FlappyMemoryView(game: GameScene(), currentApp: .constant(.flappyMemoryApp))
            .environmentObject(SwordMinder())
    }
}
