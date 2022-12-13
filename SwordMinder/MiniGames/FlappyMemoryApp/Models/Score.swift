//
//  Score.swift
//  SwordMinder
//
//  Created by Michael Smithers on 12/12/22.
//

import Foundation
import SpriteKit

class Score: SKScene {
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24

        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black

        addChild(scoreLabel)
    }
    
}
