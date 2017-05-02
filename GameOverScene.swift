//
//  GameOverScene.swift
//  MazeMan
//
//  Created by Shahir Abdul-Satar on 4/13/17.
//  Copyright © 2017 Ahmad Shahir Abdul-Satar. All rights reserved.
//

import UIKit
import SpriteKit



class GameOverScene: SKScene {
    
    var score: Int!
    
    var button: SKNode! = nil
     init(size: CGSize, score: Int) {
        
        super.init(size: size)
        self.score = score
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(gameOverLabel)
        let highScore = String(score)
        let highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.text = "High Score: " + highScore
        highScoreLabel.fontSize = 40
        
        highScoreLabel.position = CGPoint(x: size.width/3, y: size.height/3)
        self.addChild(highScoreLabel)
        let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Press Blue Button to Restart"
        restartLabel.fontSize = 40
        
        restartLabel.position = CGPoint(x: size.width/4, y: size.height/4)
        self.addChild(restartLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        /*
        let button = UIButton(frame: CGRect(x: size.width/2, y: size.height/(2/3), width: 200, height: 50))
        button.backgroundColor = UIColor.white
        button.titleLabel?.textColor = UIColor.green
        button.titleLabel!.text = "Begin New Game"
        
        //self.view?.addSubview(button)
        */
        
        
        
        
        
        
            button = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 100, height: 44))
        
            button.position = CGPoint(x: 800, y: size.height/4);
            
            self.addChild(button)
    }
    
    
    func goToGameScene(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fade(withDuration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if button.contains(location) {
                goToGameScene()
            }
        }
    }
            }

    


