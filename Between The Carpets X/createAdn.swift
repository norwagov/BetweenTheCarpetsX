//
//  createAdn.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 07/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit
import SpriteKit

class createAdn: NSObject {
    
    static func createAdnotation(in scene: SKScene, with text: String, who guy: Talker, isRankedUp rank: Bool, P: Player) {
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
                    
                    P.rankSystem?.rank += 1
                    let rank = P.rankSystem?.getRank()
                    
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
                        if P.rankSystem?.rank == 1 {
                            rankL.texture = SKTexture(imageNamed: "FatChicken")
                        }
                        if P.rankSystem?.rank == 2 {
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
    
}
