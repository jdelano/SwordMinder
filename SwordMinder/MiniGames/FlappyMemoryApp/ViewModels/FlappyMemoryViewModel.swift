//
//  FlappyMemoryViewModel.swift
//  SwordMinder
//
//  Created by Michael Smithers on 12/12/22.
//

//https://www.hackingwithswift.com/read/36/overview

import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var player: SKSpriteNode!
    var backgroundMusic: SKAudioNode!

    var logo: SKSpriteNode!
    var gameOver: SKSpriteNode!
    var gameState = GameState.showingLogo
    
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    //Attepting to read the yPosition Variable in createRocks()
    var yCollisionPos = CGFloat(0)
    
    //I was unable to fully implement this. The funtionality should go on line 203
    @Published var difficultyFlappy = DifficultyFlappy.hard

    override func didMove(to view: SKView) {
        createPlayer()
        createSky()
        createBackground()
        createGround()
        createScore()
        createLogos()

        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self

        if let musicURL = Bundle.main.url(forResource: "FlappyMemorySoundtrack", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
            
        case .showingLogo:
            gameState = .playing

            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let wait = SKAction.wait(forDuration: 0.5)
            let activatePlayer = SKAction.run { [unowned self] in
                self.player.physicsBody?.isDynamic = true
                self.startRocks()
            }

            let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
            logo.run(sequence)

        case .playing:
            //sets location to the location between the rocks. This is supposed to happen when the player speaks
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            //This sets the position to the middles of rock opening when spoken
            //player.position = CGPoint(x: frame.width / 6, y: yCollisionPos + 250)

        case .dead:
            let scene = GameScene(fileNamed: "GameScene")!
            let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
            self.view?.presentScene(scene, transition: transition)
        }
    }


    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "bird")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.50)

        addChild(player)

        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        player.physicsBody?.isDynamic = false

        player.physicsBody?.collisionBitMask = 0
    }

    func createSky() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)

        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)

        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)

        addChild(topSky)
        addChild(bottomSky)

        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }

    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")

        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            addChild(background)

            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            background.run(moveForever)
        }
    }

    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")

        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)

            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false

            addChild(ground)

            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            ground.run(moveForever)
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

    func createLogos() {
        logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: frame.midX, y: frame.midY)
        logo.setScale(1.8)
        addChild(logo)
    }

    func createRocks() {
        // 1
        let rockTexture = SKTexture(imageNamed: "rock")

        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.isDynamic = false
        topRock.zRotation = .pi
        topRock.xScale = -1.0

        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody?.isDynamic = false
        topRock.zPosition = -20
        bottomRock.zPosition = -20


        // 2
        let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height / 5))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
        rockCollision.name = "scoreDetect"

        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)


        // 3
        let xPosition = frame.width + topRock.frame.width

        let max = CGFloat(frame.height / 3)
        
        //Allows me to use this vairable outside of the func
        yCollisionPos = CGFloat.random(in: -50...max)

        // this value affects the width of the gap between rocks and is supposed to be changed by the difficulty settings
        let rockDistance: CGFloat = 70

        // 4
        topRock.position = CGPoint(x: xPosition, y: yCollisionPos + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yCollisionPos - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: yCollisionPos + 250)

        let endPosition = frame.width + (topRock.frame.width * 2)

        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
    }

    func startRocks() {
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }

        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)

        run(repeatForever)
    }

    override func update(_ currentTime: TimeInterval) {
        guard player != nil else { return }

        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)

        player.run(rotate)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }

            let sound = SKAction.playSoundFileNamed("right.wav", waitForCompletion: false)
            run(sound)

            score += 1

            return
        }

        guard contact.bodyA.node != nil && contact.bodyB.node != nil else {
            return
        }

        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let crash = SKEmitterNode(fileNamed: "PlayerCrash") {
                crash.position = player.position
                addChild(crash)
            }

            let sound = SKAction.playSoundFileNamed("crash.wav", waitForCompletion: false)
            run(sound)

            gameState = .dead
            backgroundMusic.run(SKAction.stop())

            player.removeFromParent()
            speed = 0
        }

    }
}
