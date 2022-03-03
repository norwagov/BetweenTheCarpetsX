//
//  Spawner.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 04/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import Foundation
import SpriteKit

class Spawner: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(_ P: Player, _ time: Int?) {
        
        let wait = SKAction.wait(forDuration: TimeInterval(time ?? 7))
        let spawn = SKAction.run {
            
            //let kev = Kevlar(texture: SKTexture(), color: UIColor.red, size: CGSize(width: 150, height: 150))
            //print(kev.power)
            
            //let pos = self.scene?.convert(P.position, to: self)
            
            let E = Enemy(texture: SKTexture(imageNamed: "Enemy"), color: UIColor.red, size: CGSize(width: 100, height: 100))
            
            self.parent?.addChild(E)
            
            E.position = self.position
            
            let POS = CGPoint(x: Int.random(in: -320...320), y: Int.random(in: -480...320))
            
            E.run(SKAction.move(to: POS, duration: 0.2))
            
            let ra = SKAction.run {
                
                let pos = self.scene?.convert(P.position, to: self)
                
                let random = Int.random(in: 1...5)
                
                let bullet = SKSpriteNode(color: UIColor.brown, size: CGSize(width: 30, height: 30))
                bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
                bullet.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.b)
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.p) | UInt32(PhysicsCollisionMasks.k)
                self.addChild(bullet)
                bullet.position = (self.scene?.convert(E.position, to: self))!
                bullet.physicsBody?.node?.name = "BulletA"
                bullet.physicsBody?.isDynamic = true
                bullet.run(SKAction.move(to: pos!, duration: 0.2), withKey: "bullet")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    bullet.removeFromParent() //tymczasowo 2 potem 0.2
                    if random == 3 {
                        if P.ActualStage == .szymon {
                            E.say("Amaterasu!")
                        }
                        if P.ActualStage == .wenai {
                            E.say("Jebac norwagowa")
                        }
                    }
                }
                
            }
            
            E.repeatAction(time: 3) { () -> SKAction in
                return ra
            }
            
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence), withKey: "enemys")
        
    }
    
    func stop() {
        self.removeAction(forKey: "enemys")
    }
    
}
