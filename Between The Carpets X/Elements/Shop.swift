//
//  Shop.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 04/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import Foundation
import SpriteKit

class Shop: SKSpriteNode {
    
    var items = [SKSpriteNode]()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func openShop() {
        
        let Background = SKSpriteNode(color: UIColor.white, size: CGSize(width: 400, height: 600))
        self.addChild(Background)
        Background.position = CGPoint(x: 0, y: 0)
        
    }
}
