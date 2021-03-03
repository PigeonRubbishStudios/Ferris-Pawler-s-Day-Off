//
//  TutorialScene.swift
//  Ferris Pawler's Day Off
//
//  Created by Kyle Bolinger on 4/24/19.
//  Copyright © 2019 Pigeon Rubbish Studios. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class TutorialScene: SKScene
{
    var invStar: SKSpriteNode!
    var invParticle: SKEmitterNode!
    
    override func didMove(to view: SKView)
    {
        createBackground()
        createContinueButton()
        createInvStar()
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
        let myScene = GameScene(size: size)
        myScene.scaleMode = scaleMode
        view?.presentScene(myScene)
    }
    
    func createBackground()
    {
        let mainMenuTexture = SKTexture(imageNamed: "tutorialScreen")
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
    
    func createInvStar()
    {
        let invStarTexture = SKTexture(imageNamed: "invStar")
        invStar = SKSpriteNode(texture: invStarTexture)
        invStar.position = CGPoint(x: 1374.5, y: 483)
        invStar.setScale(3)
        invStar.zPosition = 50
        
        addChild(invStar)
        
        invParticle = SKEmitterNode(fileNamed: "invStar.sks")
        invParticle.position = CGPoint(x: 1378.5, y: 477)
        invParticle.zPosition = 45
        
        addChild(invParticle)
        
    }
}
