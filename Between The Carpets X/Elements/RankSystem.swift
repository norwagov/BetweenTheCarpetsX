//
//  RankSystem.swift
//  Between The Carpets X
//
//  Created by Piotr Gawron on 06/02/2022.
//  Copyright © 2022 Piotr Gawron. All rights reserved.
//

import UIKit

class RankSystem: NSObject {
    
    var rank: Int = 0
    
    override init() {
        super.init()
    }
    
    func setRank(_ rank: Rank?) {
        switch rank {
        case .fatChicken:
            self.rank = 1
            break
        case .cookedChicken:
            self.rank = 2
            break
        default:
            self.rank = 0
            break
        }
    }
    
    func getRank() -> String {
        switch self.rank {
        case 1:
            return "Fat Chicken"
        case 2:
            return "Cooked Chicken"
        default:
            return "gówno"
        }
    }

}

enum Rank {
    case fatChicken
    case cookedChicken
}
