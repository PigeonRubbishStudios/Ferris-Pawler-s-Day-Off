//
//  GameViewController.swift
//  Ferris Pawler's Day Off
//
//  Created by Kyle Bolinger on 4/23/19.
//  Copyright © 2019 Pigeon Rubbish Studios. All rights reserved.
//

import Foundation
import SpriteKit

class GameViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let scene = MainMenuScene(size:CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
}
