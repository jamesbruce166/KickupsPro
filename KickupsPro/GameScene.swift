//
//  GameScene.swift
//  KickupsPro
//
//  Created by James Erringham-Bruce on 11/07/2021.
//

import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    @AppStorage("high_score") var highScore = 0
    @Published var currentScore = 0
    @Published var alertItem: AlertItem?
    
    let ball = SKSpriteNode(imageNamed: "ball")
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .fill
        backgroundColor = .white
        
        let border = SKPhysicsBody(edgeLoopFrom: frame)
        border.friction = 0
        physicsBody = border
        
        /// Add gravity to the world
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        makeBall()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if ball.position.y <= ball.size.height {
            alertItem = AlertContext.gameOver
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                if name == "ball" {
                    /// Velocity in X
                    let dx = (ball.position.x - positionInScene.x)
                    
                    /// ABS ensures cannot be negative, ball will always go up!
                    let dy = abs(ball.position.y - positionInScene.y) + 20
                    
                    /// Any vector, when normalized, only changes its magnitude, not its direction
                    let norm = sqrt(pow(dx, 2) + pow(dy, 2))
                    
                    /// Only apply gravity to body after first touch
                    ball.physicsBody?.affectedByGravity = true
                    
                    /// Because this impulse is applied to a specific point on the object, it may change both the body’s velocity and angular velocity.
                    ball.physicsBody?.applyImpulse(CGVector(dx: 300 * dx/norm, dy: 500 * dy/norm))
                    
                    increaseScore()
                    checkHighScore()
                }
            }
        }
    }
    
    func makeBall() {
        ball.isUserInteractionEnabled = false
        ball.name = "ball"
        ball.setScale(0.4)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        
        /// Roughness of the body
        ball.physicsBody?.friction = 0
        
        /// How much energy the physics body loses when it bounces off another object
        ball.physicsBody?.restitution = 0.7
        
        /// A property that reduces the body’s linear velocity
        ball.physicsBody?.linearDamping = 0.2
        
        ball.physicsBody?.affectedByGravity = false
        ball.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/5)
        addChild(ball)
    }
    
    func checkHighScore() {
        if currentScore >= highScore {
            highScore = currentScore
        }
    }
    
    func increaseScore() {
        currentScore += 1
    }
    
    func reset() {
        currentScore = 0

        ball.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/5)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
}
