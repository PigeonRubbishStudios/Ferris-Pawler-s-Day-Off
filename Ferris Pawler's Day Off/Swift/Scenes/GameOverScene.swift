//
//  GameOverScene.swift
//  Ferris Pawler's Day Off
//
//  Created by Kyle Bolinger on 4/29/19.
//  Copyright © 2019 Pigeon Rubbish Studios. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics
import AVFoundation

class GameOverScene: SKScene
{
    var backgroundPlayer: AVAudioPlayer!
    let highScoreLabel = SKLabelNode(fontNamed: "Showcard Gothic")
    let yourScoreLabel = SKLabelNode(fontNamed: "Showcard Gothic")
    
    override func didMove(to view: SKView)
    {
        createBackground()
        createMenuButton()
        createMusic()
        createScores()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "menuButton"
            {
                backgroundPlayer.setVolume(0.0, fadeDuration: 0.5)
                tappedDelay()
            }
        }
    }
    
    func sceneTapped()
    {
        let myScene = MainMenuScene(size: size)
        myScene.scaleMode = scaleMode
        view?.presentScene(myScene)
    }
    
    func tappedDelay()
    {
        let wait = SKAction.wait(forDuration: 0.5)
        let tappedScene = SKAction.run
        {
            self.sceneTapped()
            self.backgroundPlayer.stop()
        }
        
        self.run(SKAction.sequence([wait, tappedScene]))
    }
    
    func createBackground()
    {
        let gameOverTexture = SKTexture(imageNamed: "gameOver")
        let gameOver = SKSpriteNode(texture: gameOverTexture)
        gameOver.zPosition = -50
        gameOver.position = CGPoint(x: 768, y: 1024)
        gameOver.size = CGSize(width: 1536, height: 2048)
        addChild(gameOver)
    }
    
    func createMenuButton()
    {
        let menuButtonTexture = SKTexture(imageNamed: "menuButton")
        let menuButton = SKSpriteNode(texture: menuButtonTexture)
        menuButton.name = "menuButton"
        menuButton.zPosition = 0
        menuButton.position = CGPoint(x: 768, y: 154)
        addChild(menuButton)
    }
    
    func createMusic()
    {
        if let musicURL = Bundle.main.url(forResource: "gameOverSong", withExtension: "mp3")
        {
            do
            {
                backgroundPlayer = try AVAudioPlayer(contentsOf: musicURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            backgroundPlayer.volume = 0.02
            backgroundPlayer.numberOfLoops = -1
            backgroundPlayer.play()
        }
    }
    
    func createScores()
    {
        highScoreLabel.fontColor = UIColor(red: 0.5490196078, green: 0.03529411765, blue: 0.01568627451, alpha: 1.0)
        highScoreLabel.fontSize = 100
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        highScoreLabel.position = CGPoint(x: 20, y: 998.5)
        highScoreLabel.zPosition = 110
        yourScoreLabel.fontColor = UIColor(red: 0.5490196078, green: 0.03529411765, blue: 0.01568627451, alpha: 1.0)
        yourScoreLabel.fontSize = 100
        yourScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        yourScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        yourScoreLabel.position = CGPoint(x: 20, y: 897)
        yourScoreLabel.zPosition = 110
        
        addChild(highScoreLabel)
        addChild(yourScoreLabel)
        
        let highScoreDefaults = UserDefaults.standard
        let highScore = highScoreDefaults.object(forKey: "highScore")
        let currentScoreDefaults = UserDefaults.standard
        let yourScore = currentScoreDefaults.object(forKey: "currentScore")
        
        
        highScoreLabel.text = "High Score: \(highScore ?? 0) Blocks"
        yourScoreLabel.text = "Your Score: \(yourScore ?? 0) Blocks"
    }
}
