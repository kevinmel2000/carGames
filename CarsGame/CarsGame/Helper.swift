//
//  Helper.swift
//  CarsGame
//
//  Created by Yaniv Mashat on 9.1.2018.
//  Copyright © 2018 Nitay&Raz. All rights reserved.
//

import Foundation
import UIKit

struct ColliderType {
    static let CAR_COLLIDER : UInt32 = 0
    static let ITEM_COLLIDER : UInt32 = 1
    static let ITEM_COLLIDER_1 : UInt32 = 1
}
class Helper : NSObject {
    
    func randomBtweenTowNumbers(firsNumber : CGFloat, secondNumber : CGFloat ) -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firsNumber - secondNumber) + min(firsNumber, secondNumber)
    }
    
    
    
}

class Settings {
    static let sharedInstance = Settings()
    
    private init(){
    }
    
    var highScore = 0
}
