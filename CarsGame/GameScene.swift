//
//  GameScene.swift
//  CarsGame
//
//  Created by Yaniv Mashat on 7.1.2018.
//  Copyright © 2018 Nitay&Raz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var leftCar = SKSpriteNode()
    var rightCar = SKSpriteNode()
    var canMove = false
    var leftToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    var centerPoint: CGFloat!
    var score = 0
    
    var leftCarMinimumX: CGFloat = -280
    var leftCarMaximumX: CGFloat = -100
    
    var rightCarMinimumX: CGFloat = 100
    var rightCarMaximumX: CGFloat = 280
    
    var  countDown = 1
    var stopEverything = true
    var scoreText = SKLabelNode()
    
    var gameSettings = Settings.sharedInstance
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        setUp()
        physicsWorld.contactDelegate = self
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.creatRoadStrip), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)

         Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBtweenTowNumbers(firsNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBtweenTowNumbers(firsNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil, repeats: true)
        physicsWorld.contactDelegate = self
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        
        let deadtime  = DispatchTime.now()+1
        DispatchQueue.main.asyncAfter(deadline: deadtime) {
            
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        showRoadStrip()
        move(leftSide:leftToMoveLeft)
        moveRightCar(rightSide:rightCarToMoveRight)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar"{
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        firstBody.node?.removeFromParent()
        afterCollision()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let touchLocaion = touch.location(in: self)
            if touchLocaion.x > centerPoint {
                if rightCarAtLeft{
                    
                    rightCarAtLeft = false
                    rightCarToMoveRight = true
                    
                } else {
                    
                    rightCarToMoveRight = false
                    rightCarAtLeft = true
                }
                
                
            }else {
                
                if leftCarAtRight{
                    
                    leftCarAtRight = false
                    leftToMoveLeft = true
                    
                } else {
                    
                    leftCarAtRight = true
                    leftToMoveLeft = false
                }
                
            }
            canMove = true
        }
    }
    func setUp()  {
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        centerPoint = self.frame.size.width / self.frame.size.height
        
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        rightCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER_1 //maybe need to add 1 we dont know hope we right
        rightCar.physicsBody?.collisionBitMask = 0
        
        let scoreBackGround = SKShapeNode(rect: CGRect(x: -self.size.width/2 + 70 ,y:self.size.height/2 - 130, width: 180, height:80 ), cornerRadius: 20)
        scoreBackGround.zPosition = 4
        scoreBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackGround)
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint ( x: -self.size.width/2 + 160, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
    }
     @objc func creatRoadStrip()   {
        
        let  leftRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)

        let  rightRoadStrip = SKShapeNode(rectOf: CGSize(width: 10, height: 40))
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)

        
    }
    
    func showRoadStrip () {
        
        enumerateChildNodes(withName: "leftRoadStrip", using:  { (roadStrip, stop) in
            let stripf = roadStrip as! SKShapeNode
            stripf.position.y -= 30
        })
        enumerateChildNodes(withName: "rightRoadStrip", using: { (roadStrip, stop) in
            let stripr = roadStrip as! SKShapeNode
            stripr.position.y -= 30
        })
        enumerateChildNodes(withName: "orangeCar", using: { (leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 15
        })
        enumerateChildNodes(withName: "greenCar", using: { (rightCar, stop) in
            let car = rightCar as! SKSpriteNode
            car.position.y -= 15
        })
        
      
        
    }
    func move (leftSide: Bool)
    {
        if leftSide{
            leftCar.position.x -= 20
            if leftCar.position.x < leftCarMinimumX{
                leftCar.position.x = leftCarMinimumX
            }
            
            
        }else{
            leftCar.position.x += 20
            if leftCar.position.x > leftCarMaximumX{
                leftCar.position.x = leftCarMaximumX
            }
        }
    }
    func moveRightCar (rightSide: Bool)
    {
        if rightSide{
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarMinimumX{
                rightCar.position.x = rightCarMinimumX
            }
            
            
        }else{
            rightCar.position.x += 20
            if rightCar.position.x > rightCarMaximumX{
                rightCar.position.x = rightCarMaximumX
            }
        }
    }
    @objc func removeItems () {
        for child in children {
            if child.position.y < -self.size.height - 100{
                child.removeFromParent()
            }
        }
        
        
        
    }
    
    @objc func leftTraffic() {
        if !stopEverything {
            
            
    
        let leftTrafficItem  : SKSpriteNode
        let randomNumber = Helper().randomBtweenTowNumbers(firsNumber: 1, secondNumber: 8)
        switch Int(randomNumber) {
        case 1...4:
            leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            leftTrafficItem.name = "orangeCar"
            break
        case 5...8:
            leftTrafficItem = SKSpriteNode(imageNamed: "greenCar")
            leftTrafficItem.name = "greenCar"
            break
        default:
            leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            leftTrafficItem.name = "orangeCar"

        }
        leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leftTrafficItem.zPosition = 10
        let randomNum = Helper().randomBtweenTowNumbers(firsNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            leftTrafficItem.position.x = -280
            
            break
        case 5...10:
            leftTrafficItem.position.x = -100
            break
        default:
            leftTrafficItem.position.x = -280
        }
        leftTrafficItem.position.y = 700
        leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
        leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        leftTrafficItem.physicsBody?.collisionBitMask = 0
        leftTrafficItem.physicsBody?.affectedByGravity = false
        addChild(leftTrafficItem)
        
    
        }
    }
    @objc func rightTraffic() {
        if !stopEverything {

        let rightTrafficItem  : SKSpriteNode
        let randomNumber = Helper().randomBtweenTowNumbers(firsNumber: 1, secondNumber: 8)
        switch Int(randomNumber) {
        case 1...4:
            rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            rightTrafficItem.name = "orangeCar"
            break
        case 5...8:
            rightTrafficItem = SKSpriteNode(imageNamed: "greenCar")
            rightTrafficItem.name = "greenCar"
            break
        default:
            rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
            rightTrafficItem.name = "orangeCar"
            
        }
        rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rightTrafficItem.zPosition = 10
        let randomNum = Helper().randomBtweenTowNumbers(firsNumber: 1, secondNumber: 10)
        switch Int(randomNum) {
        case 1...4:
            rightTrafficItem.position.x = 280
            
            break
        case 5...10:
            rightTrafficItem.position.x = 100
            break
        default:
            rightTrafficItem.position.x = 280
        }
        rightTrafficItem.position.y = 700
        rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height/2)
        rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        rightTrafficItem.physicsBody?.collisionBitMask = 0
        rightTrafficItem.physicsBody?.affectedByGravity = false
        addChild(rightTrafficItem)
        
        }
        
    }
    
    func afterCollision() {
        if gameSettings.highScore < score {
            
        
        gameSettings.highScore = score
        }
        let menuScence = SKScene(fileNamed: "GameMenu")!
        menuScence.scaleMode = .aspectFill
        
            view?.presentScene(menuScence, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
        
    }
    @objc func startCountDown() {
        if countDown>0 {
            if countDown < 4 {
                
                let  CounttDownLabel = SKLabelNode()
                CounttDownLabel.fontName = "AvenirNext-Bold"
                CounttDownLabel.fontColor = SKColor.white
                CounttDownLabel.fontSize = 300
                CounttDownLabel.text = String(countDown)
                CounttDownLabel.position = CGPoint(x: 0, y: 0)
                CounttDownLabel.zPosition = 300
                CounttDownLabel.horizontalAlignmentMode = .center
                addChild(CounttDownLabel)
                
                let deadtime = DispatchTime.now()+0.5
                DispatchQueue.main.asyncAfter(deadline: deadtime, execute: {
                    CounttDownLabel.removeFromParent()
                })
                
                
            }
            countDown+=1
            if countDown == 4{
                
                self.stopEverything=false
            }
        }
        
    }
    @objc func increaseScore() {
        
        if !stopEverything {
             score += 1
            scoreText.text = String(score)
            
            
        }
    }
}
