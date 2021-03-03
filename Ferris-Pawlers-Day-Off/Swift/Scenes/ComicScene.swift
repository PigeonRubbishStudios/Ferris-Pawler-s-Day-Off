//
//  ComicScene.swift
//  Ferris Pawler's Day Off
//
//  Created by Kyle Bolinger on 4/24/19.
//  Copyright © 2019 Pigeon Rubbish Studios. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class ComicScene: SKScene
{
    var crowdSFX: SKAudioNode!
    var bellSFX: SKAudioNode!
    var pawlerCallSFX: SKAudioNode!
    
    override func didMove(to view: SKView)
    {
        createBackground()
        createContinueButton()
        createSounds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name
        {
            if name == "continueButton"
            {
                sceneTapped()
            }
        }
    }
    
    func sceneTapped()
    {
        let myScene = TutorialScene(size: size)
        myScene.scaleMode = scaleMode
        view?.presentScene(myScene)
    }
    
    func createBackground()
    {
        let mainMenuTexture = SKTexture(imageNamed: "comic")
        let mainMenu = SKSpriteNode(texture: mainMenuTexture)
        mainMenu.zPosition = -50
        mainMenu.position = CGPoint(x: 768, y: 1024)
        mainMenu.size = CGSize(width: 1536, height: 2048)
        addChild(mainMenu)
    }
    
    func createContinueButton()
    {
        let continueButtonTexture = SKTexture(imageNamed: "continueButton")
        let continueButton = SKSpriteNode(texture: continueButtonTexture)
        continueButton.name = "continueButton"
        continueButton.zPosition = 0
        continueButton.position = CGPoint(x: 768, y: 154)
        addChild(continueButton)
    }
    
    func createSounds()
    {
        let audioMaster = SKSpriteNode()
        addChild(audioMaster)
        
        if let crowdURL = Bundle.main.url(forResource: "crowd", withExtension: "mp3")
        {
            crowdSFX = SKAudioNode(url: crowdURL)
            let volumeSet = SKAction.changeVolume(to: 0.3, duration: 0)
            crowdSFX.run(volumeSet)
        }
        
        if let bellURL = Bundle.main.url(forResource: "bell", withExtension: "mp3")
        {
            bellSFX = SKAudioNode(url: bellURL)
            let volumeSet = SKAction.changeVolume(to: 0.1, duration: 0)
            bellSFX.run(volumeSet)
        }
        
        if let pawlerCallURL = Bundle.main.url(forResource: "pawlerCall", withExtension: "m4a")
        {
            pawlerCallSFX = SKAudioNode(url: pawlerCallURL)
            let volumeSet = SKAction.changeVolume(to: 0.2, duration: 0)
            pawlerCallSFX.run(volumeSet)
        }
        
        let crowdFade = SKAction.changeVolume(to: 0.0, duration: 2)
        let bellFade = SKAction.changeVolume(to: 0.0, duration: 3)
        
        let wait = SKAction.wait(forDuration: 4.5)
        let wait2 = SKAction.wait(forDuration: 5.5)
        let removePawlerCall = SKAction.run
        {
            self.pawlerCallSFX.removeFromParent()
            self.bellSFX.removeFromParent()
            self.crowdSFX.removeFromParent()
        }
        let addCrowdBell = SKAction.run
        {
            self.addChild(self.crowdSFX!)
            self.addChild(self.bellSFX!)
        }
        let addPawlerCall = SKAction.run
        {
            self.crowdSFX.run(crowdFade)
            self.bellSFX.run(bellFade)
            self.addChild(self.pawlerCallSFX!)
        }
        
        audioMaster.run(SKAction.sequence([addCrowdBell, wait, addPawlerCall, wait2, removePawlerCall]))
    }
}

