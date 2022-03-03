//
//  Kevlar.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 07/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit
import SpriteKit

class Kevlar: SKSpriteNode {

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 150)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.b)
        self.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.k)
        self.physicsBody?.node?.name = "Kevlar"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
