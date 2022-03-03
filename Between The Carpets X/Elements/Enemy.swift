//
//  Enemy.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 03/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {

    var HealthPoint: Int
    var t = false
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        self.HealthPoint = 100
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        self.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.p)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.b) | UInt32(PhysicsCollisionMasks.a)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.node?.name = "Enemy"
        
        self.name = "Enemy"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func repeatAction(time interval: Int, action: () -> SKAction) {
        let wait = SKAction.wait(forDuration: TimeInterval(interval))
        
        self.run(SKAction.repeatForever(SKAction.sequence([wait, action()])), withKey: "go")
    }
    
    func say(_ text: String) {
        let msgBox = SKSpriteNode(color: UIColor.white, size: CGSize(width: 300, height: 100))
        self.addChild(msgBox)
        msgBox.position = CGPoint(x: 216, y: 106)
        
        let textField = SKLabelNode(text: text)
        textField.fontColor = UIColor.black
        
        msgBox.addChild(textField)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            msgBox.removeFromParent()
        }
    }
    
    var simoncontrol: Bool = true
    var wenaicontrol: Bool = true
    
    func onDamage(HP: Int, scene: SKScene, _ player: Player) {
        self.HealthPoint -= HP
        switch player.ActualStage {
            case .szymon:
                if simoncontrol == true {
                    simoncontrol = false
                    if player.frags == 15 {
                        createAdn.createAdnotation(in: scene, with: "", who: .amogus, isRankedUp: true, P: player)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            createAdn.createAdnotation(in: scene, with: "Teraz będzie ciekawiej.", who: .baran, isRankedUp: false, P: player)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                createAdn.createAdnotation(in: scene, with: "Pov wenai!", who: .baran, isRankedUp: false, P: player)
                                self.simoncontrol = true
                            }
                        }
                    }
                }
                break
            case .wenai:
                if wenaicontrol == true {
                    wenaicontrol = false
                    createAdn.createAdnotation(in: scene, with: "", who: .amogus, isRankedUp: true, P: player)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        self.wenaicontrol = true
                    }
                }
                break
            default:
                break
        }
        if self.HealthPoint < 1 {
            self.removeFromParent()
            self.removeAction(forKey: "go")
            player.XP += 21
            player.frags! += 1
//            print(player.frags)
            guard t == true else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                createAdn.createAdnotation(in: scene, with: "Gratulacje!", who: .baran, isRankedUp: false, P: player)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    createAdn.createAdnotation(in: scene, with: "Przejdzmy do pov.", who: .baran, isRankedUp: false, P: player)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        createAdn.createAdnotation(in: scene, with: "Pov Szymon!", who: .baran, isRankedUp: false, P: player)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            let sceneA = SKScene(fileNamed: "Simon")
                            sceneA?.scaleMode = .aspectFill
                            scene.view?.presentScene(sceneA)
                        }
                    }
                }
            }
            
        }
    }
    
}
