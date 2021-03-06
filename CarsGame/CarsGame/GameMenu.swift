//
//  GameMenu.swift
//  CarsGame
//
//  Created by Yaniv Mashat on 30.1.2018.
//  Copyright © 2018 Nitay&Raz. All rights reserved.
//

import Foundation
import SpriteKit


class GameMenu: SKScene {
    
    var startGame = SKLabelNode()
    var  bestScore = SKLabelNode()
    var  gameSettings = Settings.sharedInstance
    
    
    
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        bestScore.text = "Best: \(gameSettings.highScore)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
        let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "startGame"{
                
                let gameScence = SKScene(fileNamed: "GameScene")!
                gameScence.scaleMode = .aspectFill
                
                view?.presentScene(gameScence, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
                
                
            }
        }
    }
}
