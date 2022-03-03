//
//  Simon.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 04/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class Simon: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //YES - attack. NO - move.
    static var mode = true
    
    static var P = Player()
    
    let shop = Shop(texture: nil, color: UIColor.red, size: CGSize(width: 250, height: 250))
    
    static func createAdnotation(in scene: SKScene, with text: String, who guy: Talker, isRankedUp rank: Bool) {
        if guy == .amogus {
            if let adn = scene.childNode(withName: "Adnotation") as! SKSpriteNode? {
                if rank == false {
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
                    
                    if let rankL = adn.childNode(withName: "Rank") as! SKSpriteNode? {
                        rankL.texture = nil
                    }
                } else {
                    
                    Simon.P.rankSystem?.rank += 1
                    let rank = Simon.P.rankSystem?.getRank()
                    
                    if let lbl = adn.childNode(withName: "AdnLabel") as! SKLabelNode? {
                        adn.run(SKAction.moveBy(x: 0, y: 300, duration: 0.3))
                        lbl.text = "Nowa ranga! \(rank!)"
      //                print("chuj")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            adn.run(SKAction.moveBy(x: 0, y: -300, duration: 0.3))
                        }
                    }
                            
                    if let tlk = adn.childNode(withName: "Talker") as! SKSpriteNode? {
                        tlk.texture = SKTexture(imageNamed: "amogus")
                    }
                    
                    if let rankL = adn.childNode(withName: "Rank") as! SKSpriteNode? {
                        if Simon.P.rankSystem?.rank == 1 {
                            rankL.texture = SKTexture(imageNamed: "FatChicken")
                        }
                        if Simon.P.rankSystem?.rank == 2 {
                            rankL.texture = SKTexture(imageNamed: "CookedChicken")
                        }
                    }
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
                
                if let rankL = adn.childNode(withName: "Rank") as! SKSpriteNode? {
                    rankL.texture = nil
                }
            }
        }
    }
    
    override func sceneDidLoad() {
        
        //print(Simon.P.position)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        Simon.createAdnotation(in: self, with: "Now: Pov Szymon!", who: .amogus, isRankedUp: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            Simon.createAdnotation(in: self, with: "Rozwal 15 Szymonów.", who: .baran, isRankedUp: false)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                Simon.createAdnotation(in: self, with: "", who: .amogus, isRankedUp: true)
//            }
        }
        
        //self.addChild(shop)
        shop.name = "Shop"
        
        Simon.P.initRankSystem()
        
        Simon.P.name = INSTANCE.name!
        Simon.P.size = INSTANCE.size!
        Simon.P.texture = INSTANCE.texture
        Simon.P.HealthPoint = INSTANCE.HealthPoint!
        Simon.P.XP = INSTANCE.XP!
        Simon.P.ActualStage = INSTANCE.ActualStage!
        Simon.P.position = INSTANCE.Position!
        
        let spawner = Spawner(texture: SKTexture(imageNamed: "dom"), color: UIColor.green, size: CGSize(width: 100, height: 100))
        spawner.position = CGPoint(x: 160, y: 320)
        self.addChild(spawner)
        spawner.start(Simon.P, 7)
        
        self.addChild(Simon.P)
        
        Simon.P.ActualStage = .szymon
        
        Simon.P.position = INSTANCE.Position!
        
        //let E = Enemy(texture: SKTexture(imageNamed: "Enemy"), color: UIColor.red, size: CGSize(width: 100, height: 100))
        
        //self.addChild(E)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        //let touchedNode = self.atPoint(pos)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            Simon.P.leaveAttack()
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name == "Aura" && contact.bodyA.node?.name == "Enemy" {
            if let enemy = contact.bodyA.node as! Enemy? {
                enemy.onDamage(HP: 99, scene: self, Simon.P)
            }
        }
        
        if contact.bodyB.node?.name == "BulletA" && contact.bodyA.node?.name == "Player" {
            if let player = contact.bodyA.node as! Player? {
                player.onDamage(HP: 2)
            }
        }
        
        if contact.bodyB.node?.name == "Bullet" && contact.bodyA.node?.name == "Enemy" {
            if let enemy = contact.bodyA.node as! Enemy? {
                enemy.onDamage(HP: 10, scene: self, Simon.P)
            }
        }
    }
    
    //vars
    
    var a: Int?
    var d: Int?
    
    var cooldown = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let position = touch?.location(in: self)
        let touchedNode = self.atPoint(position!)
            
        if touchedNode.name == "Power" {
            if cooldown == 0 {
                Simon.P.attack {
                    let aura = SKSpriteNode(texture: SKTexture(imageNamed: "Attack"))
                    
                    Simon.P.addChild(aura)
                    
                    aura.position = CGPoint(x: 0, y: 0)
                    
                    aura.physicsBody = SKPhysicsBody(circleOfRadius: 230)
                    aura.physicsBody?.collisionBitMask = 0
                    aura.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.b)
                    aura.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.a)
                    aura.name = "Aura"
                    
                    cooldown = 20
                    
                }
            }
        }
        
        if touchedNode.name == "Shop" {
            shop.openShop()
        }
        
        if Simon.mode == true {
            Simon.P.attack {
                
                let bullet = SKSpriteNode(color: UIColor.brown, size: CGSize(width: 30, height: 30))
                bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
                bullet.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.b)
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.p)
                self.addChild(bullet)
                bullet.position = Simon.P.position
                bullet.physicsBody?.node?.name = "Bullet"
                bullet.physicsBody?.isDynamic = true
                bullet.run(SKAction.move(to: (touches.first?.location(in: self))!, duration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bullet.removeFromParent()
                }
                
            }
        }
        
        if touchedNode.name == "Attack" {
            Simon.mode = true
        }
        if touchedNode.name == "Move" {
            Simon.mode = false
        }
        
        a = Int((touches.first?.location(in: self).x)!) - Int(Simon.P.position.x)
        d = Int((touches.first?.location(in: self).y)!) - Int(Simon.P.position.y)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        //-+ -- +- ++
        
        if Simon.mode == false {
            if a! < 0 && d! > 0 {
                Simon.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) + abs(a!), y: Int((touches.first?.location(in: self).y)!) - abs(d!))
            }
            
            if a! > 0 && d! < 0 {
                Simon.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) - abs(a!), y: Int((touches.first?.location(in: self).y)!) + abs(d!))
            }
            
            if a! < 0 && d! < 0 {
                Simon.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) + abs(a!), y: Int((touches.first?.location(in: self).y)!) + abs(d!))
            }
            
            if a! > 0 && d! > 0 {
                Simon.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) - abs(a!), y: Int((touches.first?.location(in: self).y)!) - abs(d!))
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
        
        print(Simon.P.frags)
        
        if Simon.P.frags == 15 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                let scene = SKScene(fileNamed: "Wenai")
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene)
            }
        }
        
        if cooldown == 20 {
            let wait = SKAction.wait(forDuration: 1)
            let go = SKAction.run {
                self.cooldown -= 1
                print(self.cooldown)
            }
            
            let sequence = SKAction.sequence([go, wait])
            self.run(SKAction.repeatForever(sequence), withKey: "countdown")
        }
        
        if cooldown == 0 {
            self.removeAction(forKey: "countdown")
        }
        
        INSTANCE.name = Simon.P.name
        INSTANCE.size = Simon.P.size
        INSTANCE.texture = Simon.P.texture
        INSTANCE.HealthPoint = Simon.P.HealthPoint
        INSTANCE.XP = Simon.P.XP
        INSTANCE.ActualStage = Simon.P.ActualStage
        INSTANCE.rankSystem = Simon.P.rankSystem
        
        if let HP = self.childNode(withName: "HPLabel") as! SKLabelNode? {
            HP.text = "\(Simon.P.HealthPoint)"
        }
        
        if let XP = self.childNode(withName: "XPLabel") as! SKLabelNode? {
            XP.text = "\(Simon.P.XP)"
        }
        
        if let STG = self.childNode(withName: "STGLabel") as! SKLabelNode? {
            STG.text = "\(Simon.P.ActualStage)"
        }
        
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
