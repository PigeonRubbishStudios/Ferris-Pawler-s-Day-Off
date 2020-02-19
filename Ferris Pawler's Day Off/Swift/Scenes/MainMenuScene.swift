//
//  MainMenuScene.swift
//  Ferris Pawler's Day Off
//
//  Created by Kyle Bolinger on 4/23/19.
//  Copyright © 2019 Pigeon Rubbish Studios. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics
import AVFoundation

class MainMenuScene: SKScene
{
    var backgroundPlayer: AVAudioPlayer!
    let highScoreLabel = SKLabelNode(fontNamed: "Showcard Gothic")
    
    override func didMove(to view: SKView)
    {
        createBackground()
        createPlayButton()
        createMusic()
        createHighScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "playButton"
            {
                backgroundPlayer.setVolume(0.0, fadeDuration: 0.5)
                tappedDelay()
            }
        }
    }
    
    func sceneTapped()
    {
        let myScene = ComicScene(size: size)
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
        let mainMenuTexture = SKTexture(imageNamed: "mainMenu")
        let mainMenu = SKSpriteNode(texture: mainMenuTexture)
        mainMenu.zPosition = -50
        mainMenu.position = CGPoint(x: 768, y: 1024)
        mainMenu.size = CGSize(width: 1536, height: 2048)
        addChild(mainMenu)
    }
    
    func createPlayButton()
    {
        let playButtonTexture = SKTexture(imageNamed: "playButton")
        let playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.name = "playButton"
        playButton.zPosition = 0
        playButton.position = CGPoint(x: 768, y: 154)
        addChild(playButton)
    }
    
    func createMusic()
    {
        if let musicURL = Bundle.main.url(forResource: "titleScreenTrack", withExtension: "mp3")
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
            backgroundPlayer.volume = 0.1
            backgroundPlayer.numberOfLoops = -1
            backgroundPlayer.play()
        }
    }
    
    func createHighScore()
    {
        highScoreLabel.fontColor = UIColor(red: 0.4980392157, green: 0.06666666667, blue: 0.0, alpha: 1.0)
        highScoreLabel.fontSize = 75
        highScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        highScoreLabel.position = CGPoint(x: 768, y: 1087)
        highScoreLabel.zPosition = 110
        
        addChild(highScoreLabel)
        
        let highScoreDefaults = UserDefaults.standard
        let highScore = highScoreDefaults.object(forKey: "highScore")
        
        
        highScoreLabel.text = "High Score: \(highScore ?? 0) Blocks"
    }
}
