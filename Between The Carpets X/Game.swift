//
//  Game.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 01/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

//THIS STAGE IS TUTORIAL!

class Game: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //YES - attack. NO - move.
    static var mode = true
    
    let P = Player(texture: SKTexture(imageNamed: "amogus"), color: UIColor.red, size: CGSize(width: 100, height: 100))
    
    let E = Enemy(texture: SKTexture(imageNamed: "Enemy"), color: UIColor.red, size: CGSize(width: 100, height: 100))
    
    static func createAdnotation(in scene: SKScene, with text: String, who guy: Talker) {
        if guy == .amogus {
            if let adn = scene.childNode(withName: "Adnotation") as! SKSpriteNode? {
                if let lbl = adn.childNode(withName: "AdnLabel") as! SKLabelNode? {
                    adn.run(SKAction.moveBy(x: 0, y: 300, duration: 0.3))
                    lbl.text = text
    //                print("chuj")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        adn.run(SKAction.moveBy(x: 0, y: -300, duration: 0.3))
                    }
                }
                
                if let tlk = adn.childNode(withName: "Talker") as! SKSpriteNode? {
                    tlk.texture = SKTexture(imageNamed: "amogus")
                }
            }
        }
        if guy == .baran {
            if let adn = scene.childNode(withName: "Adnotation") as! SKSpriteNode? {
                if let lbl = adn.childNode(withName: "AdnLabel") as! SKLabelNode? {
                    adn.run(SKAction.moveBy(x: 0, y: 300, duration: 0.3))
                    lbl.text = text
    //                print("chuj")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        adn.run(SKAction.moveBy(x: 0, y: -300, duration: 0.3))
                    }
                }
                
                if let tlk = adn.childNode(withName: "Talker") as! SKSpriteNode? {
                    tlk.texture = SKTexture(imageNamed: "Owca")
                }
            }
        }
    }
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        Game.createAdnotation(in: self, with: "Witaj w Dywanowie!", who: .amogus)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            Game.self.createAdnotation(in: self, with: "Now: Tutorial", who: .amogus)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                Game.self.createAdnotation(in: self, with: "Sprobuj zabic sebe.", who: .baran)
            }
        }
        self.addChild(E)
        self.addChild(P)
        E.t = true
        P.ActualStage = .tutorial
        P.name = "Player"
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        let touchedNode = self.atPoint(pos)
        
        P.leaveAttack()

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name == "Bullet" && contact.bodyA.node?.name == "Enemy" {
            if let enemy = contact.bodyA.node as! Enemy? {
                enemy.onDamage(HP: 10, scene: self, P)
            }
        }
    }
    
    //vars
    
    var a: Int?
    var d: Int?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let position = touch?.location(in: self)
        let touchedNode = self.atPoint(position!)
            
        if Game.mode == true {
            P.attack {
                
                let bullet = SKSpriteNode(color: UIColor.brown, size: CGSize(width: 30, height: 30))
                bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
                bullet.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.b)
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.p)
                self.addChild(bullet)
                bullet.position = P.position
                bullet.physicsBody?.node?.name = "Bullet"
                bullet.physicsBody?.isDynamic = true
                bullet.run(SKAction.move(to: (touches.first?.location(in: self))!, duration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bullet.removeFromParent()
                }
                
            }
        }
        
        if touchedNode.name == "Attack" {
            Game.mode = true
        }
        if touchedNode.name == "Move" {
            Game.mode = false
        }
        
        a = Int((touches.first?.location(in: self).x)!) - Int(P.position.x)
        d = Int((touches.first?.location(in: self).y)!) - Int(P.position.y)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        //-+ -- +- ++
        
        if Game.mode == false {
            if a! < 0 && d! > 0 {
                P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) + abs(a!), y: Int((touches.first?.location(in: self).y)!) - abs(d!))
            }
            
            if a! > 0 && d! < 0 {
                P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) - abs(a!), y: Int((touches.first?.location(in: self).y)!) + abs(d!))
            }
            
            if a! < 0 && d! < 0 {
                P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) + abs(a!), y: Int((touches.first?.location(in: self).y)!) + abs(d!))
            }
            
            if a! > 0 && d! > 0 {
                P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) - abs(a!), y: Int((touches.first?.location(in: self).y)!) - abs(d!))
            }
        }
        
    }
    
    func generateTiledTexture(size: CGSize, imageNamed imageName: String) -> SKTexture? {
        var texture: SKTexture?

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        if let image = UIImage(named: imageName), let cgImage = image.cgImage {
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width * 2, height: image.size.height * 2), byTiling: true)

            if let tiledImage = UIGraphicsGetImageFromCurrentImageContext() {
                texture = SKTexture(image: tiledImage)
            }
        }

        UIGraphicsEndImageContext()

        return texture
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        INSTANCE.name = P.name
        INSTANCE.size = P.size
        INSTANCE.texture = P.texture
        INSTANCE.HealthPoint = P.HealthPoint
        INSTANCE.XP = P.XP
        INSTANCE.ActualStage = P.ActualStage
        INSTANCE.Position = P.position
        
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    
    }

}

enum bodyType: UInt32 {
    case bullet = 1
    case body = 2
}

struct PhysicsCollisionMasks {
    static let b = 1 << 1
    static let p = 1 << 2
    static let a = 1 << 3
    static let k = 1 << 4
}
