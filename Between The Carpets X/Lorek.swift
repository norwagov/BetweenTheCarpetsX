//
//  Wenai.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 04/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class Lorek: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //YES - attack. NO - move.
    static var mode = true
    
    var P: Player = Player()
    
    var kev: Bool = false
    
    let shop = Shop(texture: nil, color: UIColor.red, size: CGSize(width: 250, height: 250))
    
    var kevcooldown: Int = 0
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        createAdn.createAdnotation(in: self, with: "Now: Pov Lorek!", who: .amogus, isRankedUp: false, P: P)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            createAdn.createAdnotation(in: self, with: "Koniec żartów.", who: .baran, isRankedUp: false, P: self.P)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                createAdn.createAdnotation(in: self, with: "Rozpierdziel te lorki!", who: .amogus, isRankedUp: false, P: self.P)
            }
        }
        
        //self.addChild(shop)
        shop.name = "Shop"
        
        //self.P = Player()
        
        self.P.name = INSTANCE.name!
        self.P.size = INSTANCE.size!
        self.P.texture = INSTANCE.texture
        self.P.HealthPoint = INSTANCE.HealthPoint!
        self.P.XP = INSTANCE.XP!
        self.P.ActualStage = INSTANCE.ActualStage!
        self.P.position = INSTANCE.Position!
        self.P.rankSystem = INSTANCE.rankSystem!
        self.P.frags = 0
        
        let spawner = Spawner(texture: SKTexture(imageNamed: "dom"), color: UIColor.green, size: CGSize(width: 100, height: 100))
        spawner.position = CGPoint(x: 160, y: -320)
        self.addChild(spawner)
        spawner.start(self.P, 6)
        
        self.addChild(self.P)
        
        self.P.ActualStage = .lorek
        
        self.P.position = INSTANCE.Position!
        
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
            self.P.leaveAttack()
        }
        
        if let kevlar = self.P.childNode(withName: "KEV") as? Kevlar? {
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                kevlar?.removeFromParent()
            }
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name == "Aura" && contact.bodyA.node?.name == "Enemy" {
            if let enemy = contact.bodyA.node as! Enemy? {
                enemy.onDamage(HP: 100, scene: self, self.P)
            }
        }
        
        if contact.bodyB.node?.name == "BulletA" && contact.bodyA.node?.name == "Player" {
            if let player = contact.bodyA.node as! Player? {
                if self.kev == false {
                    player.onDamage(HP: 3)
                } else {
                    player.onDamage(HP: 2)
                }
            }
        }
        
        if contact.bodyB.node?.name == "Bullet" && contact.bodyA.node?.name == "Enemy" {
            if let enemy = contact.bodyA.node as! Enemy? {
                enemy.onDamage(HP: 10, scene: self, self.P)
            }
        }
        
        if contact.bodyB.node?.name == "Enemy" && contact.bodyA.node?.name == "Bullet" {
            if let enemy = contact.bodyB.node as! Enemy? {
                enemy.onDamage(HP: 10, scene: self, self.P)
            }
        }
        
        if contact.bodyB.node?.name == "Kevlar" && contact.bodyA.node?.name == "BulletA" {
            if let nodeA = contact.bodyA.node {
                nodeA.removeFromParent()
                //print(nodeA.action(forKey: "bullet"))
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
                self.P.attack {
                    let aura = SKSpriteNode(texture: SKTexture(imageNamed: "Attack"))
                    
                    self.P.addChild(aura)
                    
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
        
        if touchedNode.name == "Kevlar" {
            if self.kevcooldown == 0 {
                let kevlar = Kevlar(texture: SKTexture(imageNamed: "Kevlar"), color: UIColor.green, size: CGSize(width: 230, height: 230))
                kevlar.name = "KEV"
                self.P.addChild(kevlar)
                self.kev = true
                self.kevcooldown = 30
            }
        }
        
        if Wenai.mode == true {
            self.P.attack {
                
                let bullet = SKSpriteNode(color: UIColor.brown, size: CGSize(width: 30, height: 30))
                bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
                bullet.physicsBody?.categoryBitMask = UInt32(PhysicsCollisionMasks.b)
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = UInt32(PhysicsCollisionMasks.p)
                self.addChild(bullet)
                bullet.position = self.P.position
                bullet.physicsBody?.node?.name = "Bullet"
                bullet.physicsBody?.isDynamic = true
                bullet.run(SKAction.move(to: (touches.first?.location(in: self))!, duration: 0.2))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bullet.removeFromParent()
                }
                
            }
        }
        
        if touchedNode.name == "Attack" {
            Wenai.mode = true
        }
        if touchedNode.name == "Move" {
            Wenai.mode = false
        }
        
        a = Int((touches.first?.location(in: self).x)!) - Int(self.P.position.x)
        d = Int((touches.first?.location(in: self).y)!) - Int(self.P.position.y)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
        //-+ -- +- ++
        
        if Wenai.mode == false {
            if a! < 0 && d! > 0 {
                self.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) + abs(a!), y: Int((touches.first?.location(in: self).y)!) - abs(d!))
            }
            
            if a! > 0 && d! < 0 {
                self.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) - abs(a!), y: Int((touches.first?.location(in: self).y)!) + abs(d!))
            }
            
            if a! < 0 && d! < 0 {
                self.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) + abs(a!), y: Int((touches.first?.location(in: self).y)!) + abs(d!))
            }
            
            if a! > 0 && d! > 0 {
                self.P.position = CGPoint(x: (Int((touches.first?.location(in: self).x)!)) - abs(a!), y: Int((touches.first?.location(in: self).y)!) - abs(d!))
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
        
        print(INSTANCE.Position)
        
        if kevcooldown == 30 {
            let wait = SKAction.wait(forDuration: 1)
            let go = SKAction.run {
                self.kevcooldown -= 1
                print(self.kevcooldown)
            }
            
            let sequence = SKAction.sequence([go, wait])
            self.run(SKAction.repeatForever(sequence), withKey: "kevcountdown")
        }
        
        if kevcooldown == 0 {
            self.removeAction(forKey: "kevcountdown")
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
        
        INSTANCE.name = self.P.name
        INSTANCE.size = self.P.size
        INSTANCE.texture = self.P.texture
        INSTANCE.HealthPoint = self.P.HealthPoint
        INSTANCE.XP = self.P.XP
        INSTANCE.ActualStage = self.P.ActualStage
        INSTANCE.rankSystem = self.P.rankSystem
        
        if let HP = self.childNode(withName: "HPLabel") as! SKLabelNode? {
            HP.text = "\(self.P.HealthPoint)"
        }
        
        if let XP = self.childNode(withName: "XPLabel") as! SKLabelNode? {
            XP.text = "\(self.P.XP)"
        }
        
        if let STG = self.childNode(withName: "STGLabel") as! SKLabelNode? {
            STG.text = "\(self.P.ActualStage)"
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
