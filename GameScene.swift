//
//  GameScene.swift
//  MazeMan
//
//  Created by Shahir Abdul-Satar on 4/4/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    var backgroundImage = SKSpriteNode(imageNamed: "bg")
    var block = SKSpriteNode(imageNamed: "block")
    var player = SKSpriteNode(imageNamed: "caveman")
    var water = SKSpriteNode(imageNamed: "water")
    var highScoresArray: Array<Int>!
    var width: CGFloat!
    var height: CGFloat!
    var x: CGFloat!
    var y: CGFloat!
    var health = 100
    var heart = 3
    var rocks = 10
    var starCount = 0
    var dino1: SKSpriteNode!
    var dino2: SKSpriteNode!
    var dino3: SKSpriteNode!
    var dino4: SKSpriteNode!
    var star: SKSpriteNode!
    var food: SKSpriteNode!
    var fireBall: SKSpriteNode!
    //var yArray = [Double]()
    //var xArray = [Double]()
    //var yArray: Array<Double>!
    //var xArray: Array<Double>!
    var blockArray: Array<SKSpriteNode>!
    var starNumber: SKLabelNode!
    var rockNumber: SKLabelNode!
    var heartNumber: SKLabelNode!
    var healthNumber: SKLabelNode!
    var message: SKLabelNode!
    
    let right = SKAction.moveBy(x: 150, y: 0, duration: 1)
    let left = SKAction.moveBy(x: -150, y: 0, duration: 1)
    let up  = SKAction.moveBy(x: 0, y: 150, duration: 1)
    let down = SKAction.moveBy(x: 0, y: -150, duration: 1)
    var borderBody: SKPhysicsBody!
    func swipedRight(sender:UISwipeGestureRecognizer) {
        player.xScale = -1
                player.run(right)
    }
    func swipedLeft(sender: UISwipeGestureRecognizer){
        player.xScale = 1
        player.run(left)
    }
    
    func swipedUp(sender: UISwipeGestureRecognizer){
        player.xScale = 1
        player.run(up)
    }
    func swipedDown(sender: UISwipeGestureRecognizer){
        player.xScale = 1
        player.run(down)
    }
    
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        width = frame.size.width/16
        height = frame.size.height/12
        x = frame.size.width/32
        y = frame.size.height/24
        backgroundImage.size = self.frame.size
        backgroundImage.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(backgroundImage)
        block.position = CGPoint(x: x, y: y)
        block.size = CGSize(width: width, height: height)
        addChild(block)
        player.name = "player"
        player.position = CGPoint(x: x, y: (3/2)*block.size.height)
        player.size = CGSize(width: width, height: height)
        player.zPosition = 1
        player.xScale = -1
        addChild(player)
        
        
        let water1 = SKSpriteNode(imageNamed: "water")
        let water2 = SKSpriteNode(imageNamed: "water")
        water1.name = "water1"
        water2.name = "water2"
        water1.zPosition = 2
        water2.zPosition = 2
        water1.position = CGPoint(x: CGFloat(11)*x, y: y)
        water2.position = CGPoint(x: CGFloat(23)*x, y: y)
        water1.size = CGSize(width: width, height: height)
        water2.size = CGSize(width: width, height: height)
        addChild(water1)
        addChild(water2)
    
        /*
        block.position = CGPoint(x: x, y: (11/12)*frame.size.height)
        block.size = CGSize(width: width, height: height)
        addChild(block)
        */
        let blcBottom = blockBottom(count: 16)
        let blcTop = blockTop(count1: 16 )
        for item in blcBottom {
               item.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: item.size.width, height: item.size.height))
            item.physicsBody?.affectedByGravity = false
            item.physicsBody?.isDynamic = false
            item.physicsBody?.categoryBitMask = PhysicsCategory.block.rawValue
            item.physicsBody?.collisionBitMask = 0
            item.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
            item.physicsBody?.usesPreciseCollisionDetection = true
            item.zPosition = 1
                addChild(item)
            
            
            
        }
        for i in blcTop {
            i.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: i.size.width, height: i.size.height))
            i.physicsBody?.affectedByGravity = false
            i.physicsBody?.isDynamic = false
            i.physicsBody?.categoryBitMask = PhysicsCategory.block.rawValue
            i.physicsBody?.collisionBitMask = 0
            i.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
            i.physicsBody?.usesPreciseCollisionDetection = true
            i.zPosition = 1
            addChild(i)
        }
        
        borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //borderBody.friction = 0
        
        self.physicsBody = borderBody
        self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        self.physicsBody?.collisionBitMask = 0
        addPhysics()
        addBitMasks()
        addBottomBar()
        addMessageBox()
        addBlockSequence()
        addStar()
        addFood()
        addGameBlocks()
        updateHealth()
        addDino1()
        addDino2()
        addDino3()
        addDino4()
        addFireBall()
        getMoreRocks()
        
                //highScoresArray.append(starCount)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)

        
        
        
    }
    
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as! UITouch
        let touchLocation = touch.location(in: self)
        rocks -= 1
        rockNumber.text = String(rocks)
        if rocks < 0 {
            message.text = "YOU RAN OUT OF ROCKS!"
            
        }
        let targetingVector = touchLocation //- player.position
        if (targetingVector.y > 0)  && (rocks > 0){
            throwRock(targetingVector: targetingVector)
        }
    }
    func getMoreRocks(){
        if rocks < 10 {
            rocks += 1
            let wait = SKAction.wait(forDuration: 30)
            self.run(wait)
            
        }
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == PhysicsCategory.player.rawValue) && (contact.bodyB.categoryBitMask == PhysicsCategory.block.rawValue || contact.bodyB.categoryBitMask == PhysicsCategory.border.rawValue)   {
            player.removeAllActions()
        }
        
        
        var firstBody: SKPhysicsBody!
        var secondBody: SKPhysicsBody!
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
            if (firstBody.categoryBitMask == PhysicsCategory.rock.rawValue &&
            secondBody.categoryBitMask == PhysicsCategory.enemy.rawValue) {
                print("rock hit dino")
                firstBody.node?.removeFromParent()
                secondBody.node?.removeFromParent()
                
                if secondBody.node?.name == "dino1" {
                    addDino1()
                }
                if secondBody.node?.name == "dino2" {
                    addDino2()
                }
                if secondBody.node?.name == "dino3" {
                    addDino3()
                }
                if secondBody.node?.name == "fire" {
                    addFireBall()
                }
            //killEnemy(rock: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.enemy.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.rock.rawValue){
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            if firstBody.node?.name == "dino1" {
                addDino1()
            }
            if firstBody.node?.name == "dino2" {
                addDino2()
            }
            if firstBody.node?.name == "dino3" {
                addDino3()
            }
            if firstBody.node?.name == "fire" {
                addFireBall()
            }

        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.player.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.star.rawValue) {
            starCount += 1
            secondBody.node?.removeFromParent()
            starNumber.text = String(starCount)
            
            print(starCount)
           // highScoresArray.append(starCount)
            message.text = "GOOD JOB! KEEP IT UP!"
                self.addStar()
            
            
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.player.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.food.rawValue) {
            health += 50
            secondBody.node?.removeFromParent()
            healthNumber.text = String(health)
            message.text = "FOUND SOME FOOD!"
            self.addFood()
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.player.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.enemy.rawValue){
            if secondBody.node?.name == "dino1"{
                health -= 60
                
        }
            if secondBody.node?.name == "dino2"{
                health -= 80
            
            }
            if secondBody.node?.name == "dino3"{
                heart -= 1
                heartNumber.text = String(heart)
            }
            if secondBody.node?.name == "fire"{
                
                heart -= 1
                heartNumber.text = String(heart)
            }
            message.text = "WATCH OUT FOR DINOSOURS!"
        
            }
        if (firstBody.categoryBitMask == PhysicsCategory.enemy.rawValue && firstBody.node?.name == "dino3") && (secondBody.categoryBitMask == PhysicsCategory.block.rawValue) {
            secondBody.node?.removeAllActions()
        }
        if (firstBody.categoryBitMask == PhysicsCategory.player.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.border.rawValue) {
            player.removeAllActions()
        }
    }
    
    func killEnemy(rock: SKSpriteNode, enemy: SKSpriteNode) {
        
        
        
        rock.removeFromParent()
        enemy.removeFromParent()
    }

    
    
    
    
    
    
    
    func addBitMasks(){
        player.physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        player.physicsBody?.collisionBitMask = 0
            //PhysicsCategory.block.rawValue | PhysicsCategory.enemy.rawValue
        player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.block.rawValue | PhysicsCategory.border.rawValue
        player.physicsBody?.usesPreciseCollisionDetection = true
        borderBody.categoryBitMask = PhysicsCategory.border.rawValue
        borderBody.collisionBitMask = PhysicsCategory.player.rawValue
        borderBody.usesPreciseCollisionDetection = true
        //borderBody.contactTestBitMask = PhysicsCategory.player.rawValue
        //self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        //self.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        //self.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    }
    
    
    func addPhysics(){
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        
       
    }
    
    func addBlockSequence(){
        let block = SKAction.run{self.addGameBlocks()}
        let a1 = SKAction.wait(forDuration: 1)
        let sq = SKAction.sequence([block, a1])
        self.run(SKAction.repeat(sq, count: 15))
        
    }
    
    func updateHealth(){
        let h = SKAction.run { self.decreaseHealth()  }
        let a1 = SKAction.wait(forDuration: 1)
        let sq = SKAction.sequence([h,a1])
        let rept = SKAction.repeat(sq, count: 100)
        self.run(SKAction.repeat(rept, count: 3))
        //self.run(SKAction.repeat(sq, count: 100))
    }
   
    
    
    func enableGravity(){
        let wait = SKAction.wait(forDuration: 50)
        let a1 = SKAction.run {
            self.player.physicsBody?.affectedByGravity = true
        }
        
        
    }
    
    func addGameBlocks(){
        let gameBlock = SKSpriteNode(imageNamed: "block")
        gameBlock.name = "gameBlock"
        var yArray = [Double]()
        var xArray = [Double]()
        let y1 = 128.0
        let y2 = 213.3333333331
        let y3 = 298.66666666
        let y4 = 384.0
        let y5 = 469.3333333331
        let y6 = 554.6666666663
        let y7 = 640.0
        let y8 = 725.333333333
        let y9 = 810.666666666
        
        yArray.append(y1)
        yArray.append(y2)
        yArray.append(y3)
        yArray.append(y4)
        yArray.append(y5)
        yArray.append(y6)
        yArray.append(y7)
        yArray.append(y8)
        yArray.append(y9)
        
        let x1 = Double(CGFloat(3)*x)
        let x2 = Double(CGFloat(5)*x)
        let x3 = Double(CGFloat(7)*x)
        let x4 = Double(CGFloat(9)*x)
        let x5 = Double(CGFloat(11)*x)
        let x6 = Double(CGFloat(13)*x)
        let x7 = Double(CGFloat(15)*x)
        let x8 = Double(CGFloat(17)*x)
        let x9 = Double(CGFloat(19)*x)
        let x10 = Double(CGFloat(21)*x)
        let x11 = Double(CGFloat(23)*x)
        let x12 = Double(CGFloat(25)*x)
        let x13 = Double(CGFloat(27)*x)
        let x14 = Double(CGFloat(29)*x)
        xArray.append(x1)
        xArray.append(x2)
        xArray.append(x3)
        xArray.append(x4)
        xArray.append(x5)
        xArray.append(x6)
        xArray.append(x7)
        xArray.append(x8)
        xArray.append(x9)
        xArray.append(x10)
        xArray.append(x11)
        xArray.append(x12)
        xArray.append(x13)
        xArray.append(x14)
        
        let randomY = Int(arc4random_uniform(UInt32(yArray.count)))
        let randomX = Int(arc4random_uniform(UInt32(xArray.count)))
        
        
        
        
        let valueX = xArray[randomX]
        let valueY = yArray[randomY]
        
        
        
        
        let randomPos = CGPoint(x: valueX, y: valueY)
        gameBlock.position = randomPos
        if star.frame.contains(randomPos) || food.frame.contains(randomPos) {
            let randomY2 = Int(arc4random_uniform(UInt32(yArray.count)))
            let randomX2 = Int(arc4random_uniform(UInt32(xArray.count)))
            let randomPos2 = CGPoint(x: randomX2, y: randomY2)
            gameBlock.position = randomPos2
        }

        
        
        gameBlock.size = CGSize(width: width, height: height)
        gameBlock.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: gameBlock.size.width, height: gameBlock.size.height))
        gameBlock.physicsBody?.affectedByGravity = false
        gameBlock.physicsBody?.isDynamic = false
        gameBlock.physicsBody?.categoryBitMask = PhysicsCategory.block.rawValue
        gameBlock.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        gameBlock.physicsBody?.usesPreciseCollisionDetection = true
        gameBlock.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        gameBlock.zPosition = 1
        addChild(gameBlock)
        
    }
    func addDino1(){
        
        var yArray = [Double]()
        var xArray = [Double]()
        let y1 = 128.0
        let y2 = 213.3333333331
        let y3 = 298.66666666
        let y4 = 384.0
        let y5 = 469.3333333331
        let y6 = 554.6666666663
        let y7 = 640.0
        let y8 = 725.333333333
        let y9 = 810.666666666
        
        yArray.append(y1)
        yArray.append(y2)
        yArray.append(y3)
        yArray.append(y4)
        yArray.append(y5)
        yArray.append(y6)
        yArray.append(y7)
        yArray.append(y8)
        yArray.append(y9)
        let x5 = Double(CGFloat(11)*x)
        let x11 = Double(CGFloat(23)*x)
        xArray.append(x5)
        xArray.append(x11)
        
        let randomY = Int(arc4random_uniform(UInt32(yArray.count)))
        let randomX = Int(arc4random_uniform(UInt32(xArray.count)))
        
        
        
        
        let valueX = xArray[randomX]
        _ = yArray[randomY]
        
        dino1 = SKSpriteNode(imageNamed: "dino1")
        dino1.name = "dino1"
        dino1.position = CGPoint(x: valueX, y: 950)
        dino1.zPosition = 1
        dino1.size = CGSize(width: width, height: height)
        addChild(dino1)
        dino1.zPosition = 1
        let a1 = SKAction.moveBy(x: 0, y: -850, duration: 7)
        let wait = SKAction.wait(forDuration: 2)
        let a2 = SKAction.reversed(a1)
        
        let sq = SKAction.sequence([wait, a1, wait, a2()])
        dino1.run(SKAction.repeatForever(sq))
        
        dino1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        dino1.physicsBody?.affectedByGravity = false
        dino1.physicsBody?.isDynamic = true
        dino1.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        dino1.physicsBody?.collisionBitMask = 0
        dino1.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.rock.rawValue
        
        
    
    }
    
    func addDino2(){
        
        var yArray = [Double]()
        var xArray = [Double]()
        let y1 = 128.0
        let y2 = 213.3333333331
        let y3 = 298.66666666
        let y4 = 384.0
        let y5 = 469.3333333331
        let y6 = 554.6666666663
        let y7 = 640.0
        let y8 = 725.333333333
        let y9 = 810.666666666
        
        yArray.append(y1)
        yArray.append(y2)
        yArray.append(y3)
        yArray.append(y4)
        yArray.append(y5)
        yArray.append(y6)
        yArray.append(y7)
        yArray.append(y8)
        yArray.append(y9)
        
        let x9 = Double(CGFloat(19)*x)
        let x10 = Double(CGFloat(21)*x)
        let x11 = Double(CGFloat(23)*x)
        let x12 = Double(CGFloat(25)*x)
        let x13 = Double(CGFloat(27)*x)
        let x14 = Double(CGFloat(29)*x)
        xArray.append(x9)
        xArray.append(x10)
        xArray.append(x11)
        xArray.append(x12)
        xArray.append(x13)
        xArray.append(x14)
        
        let randomY = Int(arc4random_uniform(UInt32(yArray.count)))
        let randomX = Int(arc4random_uniform(UInt32(xArray.count)))
        
        
        
        
        let valueX = xArray[randomX]
        let valueY = yArray[randomY]
        


        dino2 = SKSpriteNode(imageNamed: "dino2")
        dino2.name = "dino2"
        dino2.position = CGPoint(x: valueX, y: valueY)
        dino2.size = CGSize(width: width, height: height)
        
        addChild(dino2)
        
        let a1 = SKAction.moveBy(x: 400, y: 0, duration: 7)
        let wait = SKAction.wait(forDuration: 2)
        let a2 = SKAction.reversed(a1)
        
        let sq = SKAction.sequence([wait, a1, wait, a2()])
        dino2.zPosition = 1
        dino2.run(SKAction.repeatForever(sq))
        
        dino2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        dino2.physicsBody?.affectedByGravity = false
        dino2.physicsBody?.isDynamic = true
        dino2.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        dino2.physicsBody?.collisionBitMask = 0
        dino2.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.rock.rawValue
        
    }
    
    func addDino3(){
        var yArray = [Double]()
        var xArray = [Double]()
        let x1 = Double(CGFloat(3)*x)
        let x2 = Double(CGFloat(5)*x)
        let x3 = Double(CGFloat(7)*x)
        
        xArray.append(x1)
        xArray.append(x2)
        xArray.append(x3)
        
        
        let y7 = 640.0
        let y8 = 725.333333333
        let y9 = 810.666666666
        
        yArray.append(y7)
        yArray.append(y8)
        yArray.append(y9)
        
        let randomY = Int(arc4random_uniform(UInt32(yArray.count)))
        let randomX = Int(arc4random_uniform(UInt32(xArray.count)))
        
        
        
        
        let valueX = xArray[randomX]
        let valueY = yArray[randomY]
        
        dino3 = SKSpriteNode(imageNamed: "dino3")
        dino3.name = "dino3"
        dino3.position = CGPoint(x: valueX, y: valueY)
        dino3.size = CGSize(width: width, height: height)
        addChild(dino3)
        dino3.zPosition = 1
        let a1 = SKAction.moveBy(x: 400, y: 0, duration: 7)
        let a2 = SKAction.moveBy(x: 0, y: -300, duration: 9)
        let wait = SKAction.wait(forDuration: 2)
        let a3 = SKAction.reversed(a1)
        let a4 = SKAction.reversed(a2)
        
        let sq = SKAction.sequence([wait, a1, wait,a2, wait, a3(), wait, a4()])
        
        dino3.run(SKAction.repeatForever(sq))
        
        dino3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        dino3.physicsBody?.affectedByGravity = false
        dino3.physicsBody?.isDynamic = true
        dino3.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        dino3.physicsBody?.collisionBitMask = 0
        dino3.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.rock.rawValue | PhysicsCategory.block.rawValue
        
    }
    
    func addDino4(){
        dino4 = SKSpriteNode(imageNamed: "dino4")
        dino4.position = CGPoint(x: self.frame.midX, y: 850)
        dino4.size = CGSize(width: width, height: height)
        
        addChild(dino4)
        dino4.zPosition = 4
        let left = SKAction.moveBy(x: 300, y: 0, duration: 5)
        let rtn = SKAction.reversed(left)
        let right = SKAction.moveBy(x: 300, y: 0, duration: 5)
        let rtn2 = SKAction.reversed(right)
        let sq = SKAction.sequence([left, rtn(), right, rtn2()])
        
        dino4.run(SKAction.repeatForever(sq))
        
        dino4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        dino4.physicsBody?.affectedByGravity = false
        dino4.physicsBody?.isDynamic = false
        //dino4.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        //dino4.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
       // dino4.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        
    }
    func addFireBall(){
        fireBall = SKSpriteNode(imageNamed: "fire")
        fireBall.name = "fire"
        fireBall.position = dino4.position
        fireBall.size = CGSize(width: width, height: height)
        
        addChild(fireBall)
        fireBall.zPosition = 1
        let down = SKAction.moveBy(x: 0, y: -900, duration: 6)
        let wait = SKAction.wait(forDuration: 3)
        let reappear = SKAction.run {
            self.fireBall.position = self.dino4.position
        }
        let sq = SKAction.sequence([down, wait, reappear])
        fireBall.run(SKAction.repeatForever(sq))
        
        fireBall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        fireBall.physicsBody?.affectedByGravity = false
        fireBall.physicsBody?.isDynamic = false
        fireBall.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        fireBall.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.rock.rawValue
    }
    
    
    
    
    
    func addStar(){
        star = SKSpriteNode(imageNamed: "star")
        star.name = "star"
        star.zPosition = 1
        var yArray = [Double]()
        var xArray = [Double]()
        
        
        let y1 = 128.0
        let y2 = 213.3333333331
        let y3 = 298.66666666
        let y4 = 384.0
        let y5 = 469.3333333331
        let y6 = 554.6666666663
        let y7 = 640.0
        let y8 = 725.333333333
        let y9 = 810.666666666
        
        yArray.append(y1)
        yArray.append(y2)
        yArray.append(y3)
        yArray.append(y4)
        yArray.append(y5)
        yArray.append(y6)
        yArray.append(y7)
        yArray.append(y8)
        yArray.append(y9)
        
        let x1 = Double(CGFloat(3)*x)
        let x2 = Double(CGFloat(5)*x)
        let x3 = Double(CGFloat(7)*x)
        let x4 = Double(CGFloat(9)*x)
        let x5 = Double(CGFloat(11)*x)
        let x6 = Double(CGFloat(13)*x)
        let x7 = Double(CGFloat(15)*x)
        let x8 = Double(CGFloat(17)*x)
        let x9 = Double(CGFloat(19)*x)
        let x10 = Double(CGFloat(21)*x)
        let x11 = Double(CGFloat(23)*x)
        let x12 = Double(CGFloat(25)*x)
        let x13 = Double(CGFloat(27)*x)
        let x14 = Double(CGFloat(29)*x)
        xArray.append(x1)
        xArray.append(x2)
        xArray.append(x3)
        xArray.append(x4)
        xArray.append(x5)
        xArray.append(x6)
        xArray.append(x7)
        xArray.append(x8)
        xArray.append(x9)
        xArray.append(x10)
        xArray.append(x11)
        xArray.append(x12)
        xArray.append(x13)
        xArray.append(x14)

        let randomY = Int(arc4random_uniform(UInt32(yArray.count)))
        let randomX = Int(arc4random_uniform(UInt32(xArray.count)))
        
        
        
        
        let valueX = xArray[randomX]
        let valueY = yArray[randomY]
        star.position = CGPoint(x: valueX, y: valueY)
        
       /*
        if star.frame.contains(food.frame) {
            let randomY1 = Int(arc4random_uniform(UInt32(yArray.count)))
            let randomX1 = Int(arc4random_uniform(UInt32(xArray.count)))
            let valueX1 = xArray[randomX1]
            let valueY1 = yArray[randomY1]
            star.position = CGPoint(x: valueX1, y: valueY1)
        }
*/
        star.size = CGSize(width: width, height: height)
        addChild(star)
        star.zPosition = 1
        
        
        star.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        star.physicsBody?.affectedByGravity = false
        star.physicsBody?.isDynamic = false
        star.physicsBody?.categoryBitMask = PhysicsCategory.star.rawValue
        //star.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue
        star.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    }
    func addFood(){
        food = SKSpriteNode(imageNamed: "food")
        food.name = "food"
        food.zPosition = 1
        var yArray = [Double]()
        var xArray = [Double]()
        
        
        let y1 = 128.0
        let y2 = 213.3333333331
        let y3 = 298.66666666
        let y4 = 384.0
        let y5 = 469.3333333331
        let y6 = 554.6666666663
        let y7 = 640.0
        let y8 = 725.333333333
        let y9 = 810.666666666
        
        yArray.append(y1)
        yArray.append(y2)
        yArray.append(y3)
        yArray.append(y4)
        yArray.append(y5)
        yArray.append(y6)
        yArray.append(y7)
        yArray.append(y8)
        yArray.append(y9)
        
        let x1 = Double(CGFloat(3)*x)
        let x2 = Double(CGFloat(5)*x)
        let x3 = Double(CGFloat(7)*x)
        let x4 = Double(CGFloat(9)*x)
        let x5 = Double(CGFloat(11)*x)
        let x6 = Double(CGFloat(13)*x)
        let x7 = Double(CGFloat(15)*x)
        let x8 = Double(CGFloat(17)*x)
        let x9 = Double(CGFloat(19)*x)
        let x10 = Double(CGFloat(21)*x)
        let x11 = Double(CGFloat(23)*x)
        let x12 = Double(CGFloat(25)*x)
        let x13 = Double(CGFloat(27)*x)
        let x14 = Double(CGFloat(29)*x)
        xArray.append(x1)
        xArray.append(x2)
        xArray.append(x3)
        xArray.append(x4)
        xArray.append(x5)
        xArray.append(x6)
        xArray.append(x7)
        xArray.append(x8)
        xArray.append(x9)
        xArray.append(x10)
        xArray.append(x11)
        xArray.append(x12)
        xArray.append(x13)
        xArray.append(x14)
        
        let randomY = Int(arc4random_uniform(UInt32(yArray.count)))
        let randomX = Int(arc4random_uniform(UInt32(xArray.count)))
        
        let valueX = xArray[randomX]
        let valueY = xArray[randomY]

        food.position = CGPoint(x: valueX, y: valueY)
        food.size = CGSize(width: width, height: height)
        addChild(food)
        food.zPosition = 1
        /*if food.frame.contains(star.frame) {
            let randomY1 = Int(arc4random_uniform(UInt32(yArray.count)))
            let randomX1 = Int(arc4random_uniform(UInt32(xArray.count)))
            let valueX1 = xArray[randomX1]
            let valueY1 = yArray[randomY1]
            food.position = CGPoint(x: valueX1, y: valueY1)
        }
        */
        food.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.isDynamic = false
        food.physicsBody?.categoryBitMask = PhysicsCategory.food.rawValue
        //food.physicsBody?.collisionBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.enemy.rawValue
        food.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    }
    
    
    
    func addMessageBox(){
        message = SKLabelNode(fontNamed: "Chalkduster")
        message.color = SKColor.white
        message.text = "HELLO, WELCOME TO MAZEMAN!"
        message.zPosition = 2
        message.position = CGPoint(x: self.frame.midX, y: CGFloat(22)*y)
        let gameStatusPanel = SKSpriteNode(imageNamed: "game-status-panel")
        gameStatusPanel.position = CGPoint(x: self.frame.midX, y: CGFloat(22)*y)
        gameStatusPanel.size = CGSize(width: self.frame.size.width - (CGFloat(2)*width), height: CGFloat(2)*height)
        gameStatusPanel.alpha = 1
        gameStatusPanel.zPosition = 2
        addChild(gameStatusPanel)
        addChild(message)
        
        
        
    }
    
    func addBottomBar(){
        let starLabel = SKSpriteNode(imageNamed: "star")
        let rockLabel = SKSpriteNode(imageNamed: "rock")
        let heartLabel = SKSpriteNode(imageNamed: "heart")
        let healthLabel = SKSpriteNode(imageNamed: "battery")
        
        starLabel.position = CGPoint(x: x, y: y)
        starLabel.zPosition = 2
        starLabel.size = CGSize(width: width, height: height)
        rockLabel.position = CGPoint(x: CGFloat(3)*x, y: y)
        rockLabel.zPosition = 2
        rockLabel.size = CGSize(width: width, height: height)
        heartLabel.position = CGPoint(x: CGFloat(5)*x, y: y)
        heartLabel.zPosition = 2
        heartLabel.size = CGSize(width: width, height: height)
        healthLabel.position = CGPoint(x: CGFloat(7.5)*x, y: y)
        healthLabel.size = CGSize(width: CGFloat(1.5)*width, height: CGFloat(1.5)*height)
        healthLabel.zPosition = 2
        starNumber = SKLabelNode(fontNamed: "Chalkduster")
        starNumber.text = "0"
        starNumber.color = SKColor.white
        starNumber.zPosition = 3
        rockNumber = SKLabelNode(fontNamed: "Chalkduster")
        rockNumber.text = "10"
        rockNumber.color = SKColor.white
        rockNumber.zPosition = 3
        heartNumber = SKLabelNode(fontNamed: "Chalkduster")
        heartNumber.text = "3"
        heartNumber.color = SKColor.white
        heartNumber.zPosition = 3
        healthNumber = SKLabelNode(fontNamed: "Chalkduster")
        healthNumber.text = "100"
        healthNumber.color = SKColor.white
        healthNumber.zPosition = 3
        starNumber.position = CGPoint(x: x, y: y/2)
        rockNumber.position = CGPoint(x: CGFloat(3)*x, y: y/2)
        heartNumber.position = CGPoint(x: CGFloat(5)*x, y: y/2)
        healthNumber.position = CGPoint(x: CGFloat(7.5)*x, y: y/2)
        
        
        
        
        addChild(starLabel)
        addChild(rockLabel)
        addChild(heartLabel)
        addChild(healthLabel)
        
        addChild(starNumber)
        addChild(rockNumber)
        addChild(heartNumber)
        addChild(healthNumber)
    }
    
    func decreaseHealth(){
        health -= 1
        healthNumber.text = String(health)
        
        if health < 0 {
            heart -= 1
            heartNumber.text = String(heart)
            health = 100
            healthNumber.text = String(health)
            
            
        }
        if heart == 0 {
            
            gameOver()
        }
        
    }
    
    
    
    func throwRock(targetingVector: CGPoint) {
       
        let rock = SKSpriteNode(imageNamed: "rock")
        rock.position.x = player.position.x
        rock.position.y = player.position.y
        rock.size = CGSize(width: width/3, height: height/3)
        
        rock.physicsBody = SKPhysicsBody(circleOfRadius: rock.size.width / 2)
        rock.physicsBody?.isDynamic = false
        
        rock.physicsBody?.categoryBitMask = PhysicsCategory.rock.rawValue
        rock.physicsBody?.contactTestBitMask  = PhysicsCategory.enemy.rawValue
        rock.physicsBody?.collisionBitMask = 0
        rock.physicsBody?.usesPreciseCollisionDetection = true
        rock.zPosition = 1
        addChild(rock)
        
        
        let direction = targetingVector.normalized
        let rockVector = direction * 1000
        let rockEndPos = rockVector + rock.position
        let rockSpeed: CGFloat = 600
        let rockMoveTime = size.width / rockSpeed
        
        
        let actionMove = SKAction.move(to: rockEndPos, duration: TimeInterval(rockMoveTime))
        let actionMoveDone = SKAction.removeFromParent()
        rock.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func blockBottom(count: Int) -> [SKSpriteNode]{
        var blocks = [SKSpriteNode]()
        for _ in 0..<count {
                    let block1 = SKSpriteNode(imageNamed: "block")
                    block1.zPosition = 1
                    block1.size = CGSize(width: width, height: height)
                    blocks.append(block1)
            
            
        }
        blocks[0].position = CGPoint(x: x, y: y)
        blocks[1].position = CGPoint(x: CGFloat(3)*x, y: y)
        blocks[2].position = CGPoint(x: CGFloat(5)*x, y: y)
        blocks[3].position = CGPoint(x: CGFloat(7)*x, y: y)
        blocks[4].position = CGPoint(x: CGFloat(9)*x, y: y)
        blocks[5].position = CGPoint(x: CGFloat(11)*x, y: y)
        blocks[6].position = CGPoint(x: CGFloat(13)*x, y: y)
        blocks[7].position = CGPoint(x: CGFloat(15)*x, y: y)
        blocks[8].position = CGPoint(x: CGFloat(17)*x, y: y)
        blocks[9].position = CGPoint(x: CGFloat(19)*x, y: y)
        blocks[10].position = CGPoint(x: CGFloat(21)*x, y: y)
        blocks[11].position = CGPoint(x: CGFloat(23)*x, y: y)
        blocks[12].position = CGPoint(x: CGFloat(25)*x, y: y)
        blocks[13].position = CGPoint(x: CGFloat(27)*x, y: y)
        blocks[14].position = CGPoint(x: CGFloat(29)*x, y: y)
        blocks[15].position = CGPoint(x: CGFloat(31)*x, y: y)
        
        return blocks
    }
    
    func blockTop(count1: Int) -> [SKSpriteNode] {
        var blocks2 = [SKSpriteNode]()
        for _ in 0..<2*count1 {
            let block2 = SKSpriteNode(imageNamed: "block")
            block2.zPosition = 1
            block2.size = CGSize(width: width, height: height)
            blocks2.append(block2)
        }
        
        
        blocks2[0].position = CGPoint(x: x, y: 23*y)
        blocks2[1].position = CGPoint(x: CGFloat(3)*x, y: 23*y)
        blocks2[2].position = CGPoint(x: CGFloat(5)*x, y: 23*y)
        blocks2[3].position = CGPoint(x: CGFloat(7)*x, y: 23*y)
        blocks2[4].position = CGPoint(x: CGFloat(9)*x, y: 23*y)
        blocks2[5].position = CGPoint(x: CGFloat(11)*x, y: 23*y)
        blocks2[6].position = CGPoint(x: CGFloat(13)*x, y: 23*y)
        blocks2[7].position = CGPoint(x: CGFloat(15)*x, y: 23*y)
        blocks2[8].position = CGPoint(x: CGFloat(17)*x, y: 23*y)
        blocks2[9].position = CGPoint(x: CGFloat(19)*x, y: 23*y)
        blocks2[10].position = CGPoint(x: CGFloat(21)*x, y: 23*y)
        blocks2[11].position = CGPoint(x: CGFloat(23)*x, y: 23*y)
        blocks2[12].position = CGPoint(x: CGFloat(25)*x, y: 23*y)
        blocks2[13].position = CGPoint(x: CGFloat(27)*x, y: 23*y)
        blocks2[14].position = CGPoint(x: CGFloat(29)*x, y: 23*y)
        blocks2[15].position = CGPoint(x: CGFloat(31)*x, y: 23*y)
        blocks2[16].position = CGPoint(x: x, y: 21*y)
        blocks2[17].position = CGPoint(x: CGFloat(3)*x, y: 21*y)
        blocks2[18].position = CGPoint(x: CGFloat(5)*x, y: 21*y)
        blocks2[19].position = CGPoint(x: CGFloat(7)*x, y: 21*y)
        blocks2[20].position = CGPoint(x: CGFloat(9)*x, y: 21*y)
        blocks2[21].position = CGPoint(x: CGFloat(11)*x, y: 21*y)
        blocks2[22].position = CGPoint(x: CGFloat(13)*x, y: 21*y)
        blocks2[23].position = CGPoint(x: CGFloat(15)*x, y: 21*y)
        blocks2[24].position = CGPoint(x: CGFloat(17)*x, y: 21*y)
        blocks2[25].position = CGPoint(x: CGFloat(19)*x, y: 21*y)
        blocks2[26].position = CGPoint(x: CGFloat(21)*x, y: 21*y)
        blocks2[27].position = CGPoint(x: CGFloat(23)*x, y: 21*y)
        blocks2[28].position = CGPoint(x: CGFloat(25)*x, y: 21*y)
        blocks2[29].position = CGPoint(x: CGFloat(27)*x, y: 21*y)
        blocks2[30].position = CGPoint(x: CGFloat(29)*x, y: 21*y)
        blocks2[31].position = CGPoint(x: CGFloat(31)*x, y: 21*y)
        return blocks2
    }
    
    
    func gameOver(){
        let flipTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: self.size, score: starCount)
        gameOverScene.scaleMode = .aspectFill
        //gameOverScene.score = starCount
        self.view?.presentScene(gameOverScene, transition: flipTransition)
        
        
    }

    
    
    
    
    enum PhysicsCategory : UInt32 {
        case player = 1
        case block = 3
        case enemy = 6
        case star = 8
        case border = 10
        case food = 12
        case rock = 14
        
    }
    
    
    }


private func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

// Vector * scalar
private func *(point: CGPoint, factor: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * factor, y:point.y * factor)
}
private func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

private extension CGPoint {
    // Get the length (a.k.a. magnitude) of the vector
    var length: CGFloat { return sqrt(self.x * self.x + self.y * self.y) }
    
    // Normalize the vector (preserve its direction, but change its magnitude to 1)
    var normalized: CGPoint { return CGPoint(x: self.x / self.length, y: self.y / self.length) }
}

