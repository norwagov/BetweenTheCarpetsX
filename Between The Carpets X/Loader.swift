//
//  Loader.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 09/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit
import SpriteKit

class Loader: NSObject {
    
    //This class is being used to load scenes
    
    var object: _INSTANCE
    
    override init() {
        
        object = _INSTANCE()
        
        object.name = INSTANCE.name
        
        super.init()
        
    }
    
    

}

class _INSTANCE {

    var name: String?
    var texture: SKTexture?
    var size: CGSize?
    var HealthPoint: Int?
    var XP: Int?
    var ActualStage: Stages?
    var Position: CGPoint?
    var rankSystem: RankSystem?
    
}
