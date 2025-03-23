//
//  RollingObject.swift
//  Roll Strike
//
//  Created by Ehab Saifan on 3/6/25.
//

import SpriteKit

protocol RollingObject {
    var type: RollingObjectType { get }
    var name: String { get }
    var speed: Double { get }
}

extension RollingObject {
    // Default implementation: no custom action, use physics impulse.
    func movementAction(from start: CGPoint, with impulse: CGVector) -> SKAction? {
        return nil
    }
}

class Ball: RollingObject {
    var name = "Ball"
    var speed = 1.0
    let type = RollingObjectType.ball
}

class CrumpledPaper: RollingObject {
    var name = "Crumpled Paper"
    var speed = 2.0
    let type = RollingObjectType.crumpledPaper
}

class IronBall: RollingObject {
    var name = "Iron Ball"
    var speed = 0.8
    let type = RollingObjectType.ironBall
}
