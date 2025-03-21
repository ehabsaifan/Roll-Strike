//
//  GameScene.swift
//  Roll Strike
//
//  Created by Ehab Saifan on 3/4/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var ball: SKSpriteNode!
    private let ballSize: CGFloat = 40
    private let bottomMargin: CGFloat = 100
    
    var onBallStopped: ((CGPoint) -> Void)?
    
    private var ballStartPosition: CGPoint {
        CGPoint(x: frame.midX, y: frame.minY + bottomMargin - ball.size.height/2)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        // Set up the physics world with edge boundaries
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.gravity = .zero
        
        ball = SKSpriteNode(imageNamed: "ball")
        
        if ball.texture == nil {
            // Fallback: create a circular shape if image is not available
            ball = SKSpriteNode(color: .blue, size: CGSize(width: ballSize, height: ballSize))
            ball.name = "ball"
        }
        
        ball.size = CGSize(width: ballSize, height: ballSize)
        ball.position = ballStartPosition
        // Set a high zPosition so the ball is rendered on top of other nodes
        ball.zPosition = 10
        
        // Set up physics for the ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize / 2)
        ball.physicsBody?.restitution = 0.2
        ball.physicsBody?.friction = 0.5
        ball.physicsBody?.linearDamping = 0.3
        ball.physicsBody?.allowsRotation = true
        
        addChild(ball)
    }
    
    // Roll the ball to a random position between minY and maxY
    func rollBallToRandomPosition(maxY: CGFloat) {
        let minY = ballStartPosition.y + 50 // a little bit above the original postion at min
        //print("@@ maxY: \(maxY),  ballStartPosition: \(ballStartPosition)")
        let maxMovement = maxY - ballStartPosition.y
        let targetY = CGFloat.random(in: minY...maxMovement)
        let targetPosition = CGPoint(x: ball.position.x, y: targetY)
        let duration: TimeInterval = 1.0
        let moveAction = SKAction.move(to: targetPosition, duration: duration)
        moveAction.timingMode = .easeOut
        ball.run(moveAction) { [weak self] in
            self?.onBallStopped?(targetPosition)
            self?.onBallStopped = nil
        }
    }
    
    func applyImpulse(_ impulse: CGVector) {
        ball.physicsBody?.applyImpulse(impulse)
    }
    
    // Is this still used?
    func rollBall(to position: CGPoint) {
        let duration: TimeInterval = 1
        let moveAction = SKAction.move(to: position, duration: duration)
        ball.run(moveAction)
    }
    
    func resetBall() {
        ball.position = ballStartPosition
        ball.physicsBody?.velocity = .zero
        ball.physicsBody?.angularVelocity = .zero
    }
}
