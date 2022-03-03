//
//  Player.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 01/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit
import SpriteKit

extension CGPoint {
    func distanceFromCGPoint(point:CGPoint)->CGFloat{
        return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
    }
}

class Player: SKSpriteNode {

    var HealthPoint: Int
    var XP: Int
    var ActualStage: Stages
    
    var frags: Int? = 13  //
    
    var rankSystem: RankSystem? = nil //
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        self.HealthPoint = 100
        self.XP = 0
        self.ActualStage = .tutorial
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        self.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.p)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.b)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.node?.name = "Player"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attack(options: () -> Void) {
        
        options()
        
    }
    
    func leaveAttack() {
        
        self.childNode(withName: "Aura")?.removeFromParent()
        
    }
    
    func onDamage(HP: Int) {
        self.HealthPoint -= HP
        if self.HealthPoint < 0 {
            self.removeFromParent()
        }
    }
    
    func initRankSystem() {
        self.rankSystem = RankSystem()
        self.rankSystem?.setRank(nil)
    }
    
}
