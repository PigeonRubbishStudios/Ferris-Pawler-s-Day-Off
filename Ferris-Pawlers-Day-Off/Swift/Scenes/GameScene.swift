//
//  GameScene.swift
//  Ferris Pawler's Day Off
//
//  Created by Kyle Bolinger on 4/23/19.
//  Copyright © 2019 Pigeon Rubbish Studios. All rights reserved.

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate
{
    ////Var Variables
    //SpriteKit Node Variables
    var ferris: SKSpriteNode!
    var cat: SKSpriteNode!
    var carRight: SKSpriteNode!
    var carLeft: SKSpriteNode!
    var bone: SKSpriteNode!
    var speedParent = SKNode()
    var house: SKSpriteNode!
    var house0: SKSpriteNode!
    var house1: SKSpriteNode!
    var house2: SKSpriteNode!
    var house3: SKSpriteNode!
    var house4: SKSpriteNode!
    var house5: SKSpriteNode!
    var house6: SKSpriteNode!
    var house7: SKSpriteNode!
    var house8: SKSpriteNode!
    var school: SKSpriteNode!
    var hud: SKSpriteNode!
    var heart1: SKSpriteNode!
    var heart2: SKSpriteNode!
    var heart3: SKSpriteNode!
    var invButton: SKSpriteNode!
    var leftHousesBarrier: SKSpriteNode!
    var rightHousesBarrier: SKSpriteNode!
    var houseDestroy: SKSpriteNode!
    var invParticle: SKEmitterNode!
    var cam: SKCameraNode?
    
    //CGPoint Variables
    var touchLocation = CGPoint()
    var lastTouchLocation: CGPoint?
    var velocity = CGPoint.zero
    var velocity2 = CGPoint.zero
    var catMove = CGPoint(x: 1600, y: 100)
    
    //CGFloat Variables
    var xAcceleration = CGFloat(0)
    
    //CGSize Variables
    var hudSize = CGSize(width: 1536, height: 150)
    var barrierSize = CGSize(width: 342.9, height: 2048)
    
    //Color Node Variables
    var hudColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    var barrierColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    
    //Physics Variables
    var contactQueue = [SKPhysicsContact]()
    
    //Boolean Variables
    var invincible = false
    var invinciblePU = false
    var spawnHouse = true
    var canBark = true
    var canSpawnCat = true
    var canSpawnCar = true
    var canSpawn1 = true
    var canSpawn2 = true
    var canSpawn3 = true
    var canSpawn4 = true
    var canSpawn5 = true
    var canSpawn6 = true
    var canSpawn7 = true
    var canSpawn8 = true
    
    //TimeInterval Variables
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    //Integer Variables
    var lives = 3
    var bonesCollected = 0
    var collectablesOnScreen = 0
    var currentScore = 0
    var highScore = 328
    
    //AVFoundation Variables
    var backgroundPlayer: AVAudioPlayer!
    var invPlayer: AVAudioPlayer!
    var runningPlayer: AVAudioPlayer!
    var whinePlayer: AVAudioPlayer!
    var barkPlayer: AVAudioPlayer!
    var bonePopPlayer: AVAudioPlayer!
    var meowPlayer: AVAudioPlayer!
    var sirenPlayer: AVAudioPlayer!
    
    
    
    ////Let Variables
    //Label Variables
    let powerUpLabel = SKLabelNode(fontNamed: "Showcard Gothic")
    let scoreLabel = SKLabelNode(fontNamed: "Showcard Gothic")
    
    //Animation Variables
    let ferrisAnimation: SKAction
    let catAnimation: SKAction
    let carAnimation: SKAction
    
    //Movement variables
    let motionManager = CMMotionManager()
    let ferrisMovePointsPerSec: CGFloat = 550.0 //Ferris Speed
    
    //CGRect Variables
    let playableRect: CGRect
    
    //Name Variables
    let ferrisName = "Ferris"
    let enemyName = "Enemy"
    let schoolName = "School"
    let houseName = "House"
    let boneName = "Bone"
    let heart1Name = "Heart 1"
    let heart2Name = "Heart 2"
    let heart3Name = "Heart 3"
    let invButtonName = "Invincibility Button"
    let powerUpTextName = "Power Up Label"
    
    //Physics Category Variables
    let kFerrisCategory: UInt32 = 0x1 << 1
    let kCollectableCategory: UInt32 = 0x1 << 2
    let kDestroyCategory: UInt32 = 0x1 << 2
    let kCatCategory: UInt32 = 0x1 << 3
    let kHouseCategory: UInt32 = 0x1 << 3
    let kCarCategory: UInt32 = 0x1 << 3
    let kSceneEdgeCategory: UInt32 = 0x1 << 4
    
    
    
    ////Override Methods
    //Did Move Method
    override func didMove(to view:SKView)
    {
        //¯\_(ツ)_/¯
        super.didMove(to:view)
        
        //Bring in Physics
        self.physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        //Add the Node that Controls the Speed of the Game and Set the Speed to 1
        addChild(speedParent)
        speedParent.speed = 1
        
        //Set the Current Score to 0
        currentScore = 0
        
        //Set Up Accelerometers
        setupCoreMotion()
        
        //Bring in Sprites and Nodes
        createCamera()
        createFerris()
        createBackground()
        createSchool()
        createHouses()
        createHouseBarriers()
        createCat()
        createCars()
        createBone()
        createSounds()
        createHUD()
        createInvButton()
        createInvParticle()
        createScore()
        createHeart1()
        createHeart2()
        createHeart3()
        
        //Start Moving Houses and Increasing the Game Speed
        startHouses()
        changeSpeeds()
    }
    
    //Update Method
    override func update(_ currentTime: TimeInterval)
    {
        //Some Update Finding Bullshit ¯\_(ツ)_/¯
        if lastUpdateTime > 0
        {
            dt = currentTime - lastUpdateTime
        }
        else
        {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        //Set Up Camera Position
        if let camera = cam
        {
            camera.position = CGPoint(x: size.width/2, y: size.height/2)
        }
        
        //Tint Ferris if Invincibility Power Up is Activated
        if invinciblePU == true
        {
            let redValue = Int.random(min: Int(CGFloat(0.0)), max: Int(CGFloat(1.0)))
            let greenValue = Int.random(min: Int(CGFloat(0.0)), max: Int(CGFloat(1.0)))
            let blueValue = Int.random(min: Int(CGFloat(0.0)), max: Int(CGFloat(1.0)))
            let rainbowColor = SKColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: 1.0)
            
            let tintFerris = SKAction.colorize(with: rainbowColor, colorBlendFactor: 1.0, duration: 0)
            
            ferris.run(tintFerris)
        }
        
        //Start the Particles Around the Invincibility Button if Activatable
        if bonesCollected == 3
        {
            invParticle.particleBirthRate = 100.0
        }
        
        //Track a New High Score
        if currentScore >= highScore
        {
            highScore = currentScore
        }
        
        //Set What the Label Text Should Say
        powerUpLabel.text = "\(bonesCollected)/3"
        scoreLabel.text = "Blocks: \(currentScore)"
        
        //Check for Collisions
        processContacts(forUpdate: currentTime)
        
        //Check if Ferris is in the Playable Area
        boundsCheckFerris()
        
        //Move Ferris
        updatePlayer()
        move(sprite: ferris, velocity: velocity)

        //Randomize Cat Spawning and Move the Cat
        randomizeCatSpawn(forUpdate: currentTime)
        
        //Randomize Car Spawning and Move the Car
        randomizeCarSpawn(forUpdate: currentTime)
        
        //Randomize the Bone Spawning and Move the Bone
        randomCollectableSpawner(forUpdate: currentTime)
        
        //Randomize Ferris Barking
        randomizeBark(forUpdate: currentTime)

        //Destroy Heart Sprites
        destroyLives()
    }
    
    //Initialize Method
    override init(size: CGSize)
    {
        //Setting the Playable Area Dimensions
        let maxAspectRatio:CGFloat = 3.0/4.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        //Create an Array that will Store the Ferris Running Frames
        var ferrisTextures:[SKTexture] = []
        
        //Set "i" Equal to the Frame Number of the Image for the Animation
        for i in 0...16
        {
            ferrisTextures.append(SKTexture(imageNamed: "ferris\(i)"))
        }
        
        //Set Up Ferris Running Animation
        ferrisAnimation = SKAction.animate(with: ferrisTextures, timePerFrame: 0.05)
        
        //Create an Array that will Store the Cat Running Frames
        var catTextures:[SKTexture] = []
        
        //Set "ii" Equal to the Frame Number of the Image for the Animation
        for ii in 1...4
        {
            catTextures.append(SKTexture(imageNamed: "cat\(ii)"))
        }
        
        //Set Up the Cat Running Animation
        catAnimation = SKAction.animate(with: catTextures, timePerFrame: 0.2)
        
        //Create an Array that will Store the Car Animation Frames
        var carTextures:[SKTexture] = []
        
        //Set "iii" Equal to the Frame Number of the Image for the Animation
        for iii in 1...2
        {
            carTextures.append(SKTexture(imageNamed: "policeCar\(iii)"))
        }
        
        //Set Up the Car Animation
        carAnimation = SKAction.animate(with: carTextures, timePerFrame: 0.1)
        
        //¯\_(ツ)_/¯
        super.init(size: size)
    }
    
    //Some Bullshit Required for the Initialize Method ¯\_(ツ)_/¯
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Touches Began Method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        //If the Player Has Collected 3 Bones and Taps the InvButton, Activate Invincibility
        if let name = touchedNode.name
        {
            if bonesCollected == 3 && name == invButtonName || name == powerUpTextName 
            {
                activateInvincibility()
            }
        }
    }
    
    
    
    ////Physics Methods
    //Method to Begin Contacts
    func didBegin(_ contact: SKPhysicsContact)
    {
        contactQueue.append(contact)
    }
    
    //Method to Handle Collisions
    func handle(_ contact: SKPhysicsContact)
    {
        // Ensure you haven't already handled this contact and removed its nodes
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil
        {
            return
        }
        
        //Set Up Node Names
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]

        //Ferris Collides with Enemies
        if nodeNames.contains(ferrisName) && nodeNames.contains(enemyName) && lives >= 0 && invinciblePU == false && invincible == false
        {
            ferrisHit()
            lives = lives - 1
            whinePlayer.play()
        }

        //Ferris Collects a Bone
        if nodeNames.contains(ferrisName) && nodeNames.contains(boneName)
        {
            resetBone()
        }
    }
    
    //Method to Update Collisions
    func processContacts(forUpdate currentTime: CFTimeInterval)
    {
        for contact in contactQueue
        {
            handle(contact)
            
            if let index = contactQueue.firstIndex(of: contact)
            {
                contactQueue.remove(at: index)
            }
        }
    }
    
    //Method to Check if Ferris is Within the Playable Area and Prevent Him from Going Out
    func boundsCheckFerris()
    {
        let bottomLeft = CGPoint(x: 380.875, y: cameraRect.minY)
        let topRight = CGPoint(x: 1155.125, y: cameraRect.maxY)
        
        if ferris.position.x <= bottomLeft.x
        {
            ferris.position.x = bottomLeft.x
            velocity.x = abs(velocity.x)
        }
        if ferris.position.x >= topRight.x
        {
            ferris.position.x = topRight.x
            velocity.x = -velocity.x
        }
    }
    
    //Method Called When Ferris Collides With an Enemy
    func ferrisHit()
    {
        //Switches the Invincible Bool to True
        invincible = true
        
        //Player will Blink using Times and a Duration of 3 Seconds
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration)
        {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        
        //This Method Makes the Player Reappear and Resets the Invincibility Bool Back to False
        let setHidden = SKAction.run()
        {
            [weak self] in
            self?.ferris.isHidden = false
            self?.invincible = false
        }
        
        //This Sequence Completes Both the Blinking Action and Hiding and Making the Player Reappear.
        ferris.run(SKAction.sequence([blinkAction, setHidden]))
    }
    
    
    
    ////Accelerometer Methods
    //Method to Set Up Accelerometers
    func setupCoreMotion()
    {
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = OperationQueue()
        motionManager.startAccelerometerUpdates(to: queue, withHandler:
            {
                accelerometerData, error in
                guard let accelerometerData = accelerometerData else
                {
                    return
                }
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75) +
                    (self.xAcceleration * 0.5)
        })
    }
    
    //Method To Set Ferris Acceleration
    func updatePlayer()
    {
        // Set velocity based on core motion
        velocity.x = xAcceleration * 1000.0
    }
    
    //Ferris Movement Step 1:
    func moveFerrisToward(location: CGPoint)
    {
        let offset = location - ferris.position
        let direction = offset.normalized()
        velocity = direction * ferrisMovePointsPerSec
    }
    
    //Ferris Movement Step 2:
    func sceneTouched(touchLocation:CGPoint)
    {
        lastTouchLocation = touchLocation
        moveFerrisToward(location: touchLocation)
    }
    
    //Ferris Movement Step 3:
    func move(sprite: SKSpriteNode, velocity: CGPoint)
    {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity2.y * CGFloat(dt))
        sprite.position += amountToMove
        
        //Starts Ferris Running Animation
        startFerrisAnimation()
    }
    
    
    
    ////Create Methods
    //Set Up Ferris
    func createFerris()
    {
        //Set up the Texture and Position for Ferris
        let ferrisTexture = SKTexture(imageNamed: "ferris15")
        ferris = SKSpriteNode(texture: ferrisTexture)
        ferris.name = ferrisName
        ferris.position = CGPoint(x: 768, y: 591)
        ferris.zPosition = 50
        
        //Add Ferris to the Game
        addChild(ferris)
        
        //Set up the Physics for Ferris
        ferris.physicsBody = SKPhysicsBody(texture: ferrisTexture, size: ferrisTexture.size())
        ferris.physicsBody?.isDynamic = true
        ferris.physicsBody!.categoryBitMask = kFerrisCategory
        ferris.physicsBody!.contactTestBitMask = 0x0
        ferris.physicsBody!.collisionBitMask = kSceneEdgeCategory
    }
    
    //Set Up and Move the Background
    func createBackground()
    {
        let roadTexture = SKTexture(imageNamed: "road")
        
        for i in 0 ... 1
        {
            let roadNode = SKSpriteNode(texture: roadTexture)
            roadNode.zPosition = -50
            roadNode.anchorPoint = CGPoint.zero
            roadNode.position = CGPoint(x: 0, y: (cameraRect.size.height * CGFloat(i)) - CGFloat(1 * i))
            
            speedParent.addChild(roadNode)
            
            let moveDown = SKAction.moveBy(x: 0, y: -roadTexture.size().height, duration: 3.0)
            let moveReset = SKAction.moveBy(x: 0, y: roadTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            roadNode.run(moveForever)
        }
    }
    
    //Set Up and Move the School
    func createSchool()
    {
        let schoolTexture = SKTexture(imageNamed: "school")
        school = SKSpriteNode(texture: schoolTexture)
        school.name = schoolName
        school.position = CGPoint(x: 768, y: 834)
        school.zPosition = 55
        school.setScale(6.5)
        
        addChild(school)
        
        let moveDown = SKAction.moveTo(y: -1000, duration: 1.5)
        let remove = SKAction.removeFromParent()
        let fullMove = SKAction.sequence([moveDown, remove])
        school.run(fullMove)
    }
    
    //Set Up the Houses
    func createHouses()
    {
        let houseTexture = SKTexture(imageNamed: "house1")
        house = SKSpriteNode(texture: houseTexture)
        house.name = houseName
        house.position = CGPoint(x: -64.5, y: 2468)
        house.zPosition = 30
        
        let house0Texture = SKTexture(imageNamed: "house8")
        house0 = SKSpriteNode(texture: house0Texture)
        house0.name = houseName
        house0.position = CGPoint(x: 1555.998, y: 2468)
        house0.zPosition = 30
        
        let house1Texture = SKTexture(imageNamed: "house1")
        house1 = SKSpriteNode(texture: house1Texture)
        house1.name = houseName
        house1.position = CGPoint(x: -64.5, y: 2468)
        house1.zPosition = 30
        
        let house2Texture = SKTexture(imageNamed: "house2")
        house2 = SKSpriteNode(texture: house2Texture)
        house2.name = houseName
        house2.position = CGPoint(x: -40, y: 2468)
        house2.zPosition = 30
        
        let house3Texture = SKTexture(imageNamed: "house3")
        house3 = SKSpriteNode(texture: house3Texture)
        house3.name = houseName
        house3.position = CGPoint(x: -21.5, y: 2468)
        house3.zPosition = 30
        
        let house4Texture = SKTexture(imageNamed: "house4")
        house4 = SKSpriteNode(texture: house4Texture)
        house4.name = houseName
        house4.position = CGPoint(x: -19.5, y: 2468)
        house4.zPosition = 30
        
        let house5Texture = SKTexture(imageNamed: "house5")
        house5 = SKSpriteNode(texture: house5Texture)
        house5.name = houseName
        house5.position = CGPoint(x: 1600, y: 2468)
        house5.zPosition = 30
        
        let house6Texture = SKTexture(imageNamed: "house6")
        house6 = SKSpriteNode(texture: house6Texture)
        house6.name = houseName
        house6.position = CGPoint(x: 1577.5, y: 2468)
        house6.zPosition = 30
        
        let house7Texture = SKTexture(imageNamed: "house7")
        house7 = SKSpriteNode(texture: house7Texture)
        house7.name = houseName
        house7.position = CGPoint(x: 1555.998, y: 2468)
        house7.zPosition = 30
        
        let house8Texture = SKTexture(imageNamed: "house8")
        house8 = SKSpriteNode(texture: house8Texture)
        house8.name = houseName
        house8.position = CGPoint(x: 1555.998, y: 2468)
        house8.zPosition = 30
        
        speedParent.addChild(house)
        speedParent.addChild(house0)
        speedParent.addChild(house1)
        speedParent.addChild(house2)
        speedParent.addChild(house3)
        speedParent.addChild(house4)
        speedParent.addChild(house5)
        speedParent.addChild(house6)
        speedParent.addChild(house7)
        speedParent.addChild(house8)
    }
    
    //Set Up the Invisible Barriers that Ferris Collides With
    func createHouseBarriers()
    {
        leftHousesBarrier = SKSpriteNode(color: barrierColor, size: barrierSize)
        rightHousesBarrier = SKSpriteNode(color: barrierColor, size: barrierSize)
        leftHousesBarrier.position = CGPoint(x: 171, y: 1024)
        rightHousesBarrier.position = CGPoint(x: 1365, y: 1024)
        leftHousesBarrier.name = enemyName
        rightHousesBarrier.name = enemyName
        
        addChild(leftHousesBarrier)
        addChild(rightHousesBarrier)
        
        leftHousesBarrier.physicsBody = SKPhysicsBody(rectangleOf: barrierSize)
        rightHousesBarrier.physicsBody = SKPhysicsBody(rectangleOf: barrierSize)
        leftHousesBarrier?.physicsBody?.isDynamic = false
        rightHousesBarrier?.physicsBody?.isDynamic = false
        leftHousesBarrier!.physicsBody!.categoryBitMask = kHouseCategory
        rightHousesBarrier!.physicsBody!.categoryBitMask = kHouseCategory
        leftHousesBarrier!.physicsBody!.contactTestBitMask = kFerrisCategory
        rightHousesBarrier!.physicsBody!.contactTestBitMask = kFerrisCategory
        leftHousesBarrier!.physicsBody!.collisionBitMask = 0x0
        rightHousesBarrier!.physicsBody!.collisionBitMask = 0x0
    }
    
    //Set Up the Cat
    func createCat()
    {
        let randomCatLoc = CGFloat.random(min: 1221, max: 2000)
        let catStartLoc = CGPoint(x: -171, y: randomCatLoc)
        let catTexture = SKTexture(imageNamed: "cat1")
        cat = SKSpriteNode(texture: catTexture)
        cat.name = enemyName
        cat.position = catStartLoc
        cat.zPosition = 25
        
        speedParent.addChild(cat)
        
        cat.physicsBody = SKPhysicsBody(texture: catTexture, size: catTexture.size())
        cat.physicsBody?.isDynamic = false
        cat.physicsBody!.categoryBitMask = kCatCategory
        cat.physicsBody!.contactTestBitMask = kFerrisCategory
        cat.physicsBody!.collisionBitMask = 0x0
        
        startCatAnimation()
    }
    
    //Set Up the Police Cars
    func createCars()
    {
        let carRightStartLoc = CGPoint(x: 1260, y: 2292)
        let carLeftStartLoc = CGPoint(x: 276, y: 2292)
        let carTexture = SKTexture(imageNamed: "policeCar1")
        
        carLeft = SKSpriteNode(texture: carTexture)
        carLeft.name = enemyName
        carLeft.zRotation = -5.497787144
        carLeft.position = carLeftStartLoc
        carLeft.zPosition = 26
        
        carRight = SKSpriteNode(texture: carTexture)
        carRight.name = enemyName
        carRight.zRotation = 5.497787144
        carRight.position = carRightStartLoc
        carRight.zPosition = 26
        
        speedParent.addChild(carLeft)
        speedParent.addChild(carRight)
        
        carLeft.physicsBody = SKPhysicsBody(texture: carTexture, size: carTexture.size())
        carLeft.physicsBody?.allowsRotation = true
        carLeft.physicsBody?.isDynamic = false
        carLeft.physicsBody!.categoryBitMask = kCarCategory
        carLeft.physicsBody!.contactTestBitMask = kFerrisCategory
        carLeft.physicsBody!.collisionBitMask = 0x0
        
        carRight.physicsBody = SKPhysicsBody(texture: carTexture, size: carTexture.size())
        carRight.physicsBody?.allowsRotation = true
        carRight.physicsBody?.isDynamic = false
        carRight.physicsBody!.categoryBitMask = kCarCategory
        carRight.physicsBody!.contactTestBitMask = kFerrisCategory
        carRight.physicsBody!.collisionBitMask = 0x0
        
        startCarAnimation()
    }
    
    //Set Up the Bone Collectable
    func createBone()
    {
        let boneRandomLoc = CGPoint(x: CGFloat.random(min: 441.8, max: 1094.8), y: 2100)
        let boneTexture = SKTexture(imageNamed: "bone")
        bone = SKSpriteNode(texture: boneTexture)
        bone.name = boneName
        bone.position = boneRandomLoc
        bone.zPosition = 10
        bone.setScale(0)
        
        speedParent.addChild(bone)
        
        bone.physicsBody = SKPhysicsBody(texture: boneTexture, size: boneTexture.size())
        bone.physicsBody?.allowsRotation = true
        bone.physicsBody?.isDynamic = false
        bone.physicsBody!.categoryBitMask = kCollectableCategory
        bone.physicsBody!.contactTestBitMask = kFerrisCategory
        bone.physicsBody!.collisionBitMask = kSceneEdgeCategory
    }
    
    //Set Up All Audio in the Game
    func createSounds()
    {
        if let invURL = Bundle.main.url(forResource: "invincibility", withExtension: "mp3")
        {
            do
            {
                invPlayer = try AVAudioPlayer(contentsOf: invURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            invPlayer.enableRate = true
            invPlayer.volume = 0.0
            invPlayer.rate = 1.5
            invPlayer.numberOfLoops = -1
            invPlayer.play()
        }
        
        if let bgURL = Bundle.main.url(forResource: "FPDOSoundtrack", withExtension: "mp3")
        {
            do
            {
                backgroundPlayer = try AVAudioPlayer(contentsOf: bgURL)
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
        
        if let runningURL = Bundle.main.url(forResource: "running", withExtension: "mp3")
        {
            do
            {
                runningPlayer = try AVAudioPlayer(contentsOf: runningURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            runningPlayer.volume = 0.005
            runningPlayer.numberOfLoops = -1
            runningPlayer.play()
        }
        
        if let dogWhineURL = Bundle.main.url(forResource: "dogWhine", withExtension: "mp3")
        {
            do
            {
                whinePlayer = try AVAudioPlayer(contentsOf: dogWhineURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            whinePlayer.volume = 0.01
        }
        
        if let barkURL = Bundle.main.url(forResource: "dogBark", withExtension: "mp3")
        {
            do
            {
                barkPlayer = try AVAudioPlayer(contentsOf: barkURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            barkPlayer.volume = 0.05
        }
        
        if let popURL = Bundle.main.url(forResource: "bonePop", withExtension: "m4a")
        {
            do
            {
                bonePopPlayer = try AVAudioPlayer(contentsOf: popURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            bonePopPlayer.volume = 0.05
        }
        
        if let meowURL = Bundle.main.url(forResource: "catMeow", withExtension: "mp3")
        {
            do
            {
                meowPlayer = try AVAudioPlayer(contentsOf: meowURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            meowPlayer.volume = 0.0075
        }
        
        if let sirenURL = Bundle.main.url(forResource: "policeSiren", withExtension: "mp3")
        {
            do
            {
                sirenPlayer = try AVAudioPlayer(contentsOf: sirenURL)
            }
            catch
            {
                print("Error Playing Audio");
                return
            }
            sirenPlayer.volume = 0.015
            sirenPlayer.currentTime = 0.7
        }
    }
    
    //Set Up the HUD
    func createHUD()
    {
        hud = SKSpriteNode(color: hudColor, size: hudSize)
        hud.position = CGPoint(x: 768, y: 1973)
        hud.zPosition = 100
        
        addChild(hud)
    }
    
    //Set Up the Invincibility Button
    func createInvButton()
    {
        //Set up the Texture and Position for the Invincinbility Button Sprite
        let invButtonTexture = SKTexture(imageNamed: "invButton")
        invButton = SKSpriteNode(texture: invButtonTexture)
        invButton.name = invButtonName
        invButton.position = CGPoint(x: 1334, y: 206)
        invButton.zPosition = 60
        
        //Add InvButton to the Game
        addChild(invButton)
        
        powerUpLabel.fontColor = SKColor.white
        powerUpLabel.name = powerUpTextName
        powerUpLabel.fontSize = 50
        powerUpLabel.position = CGPoint(x: 11.421, y: -42)
        powerUpLabel.zPosition = 75
        powerUpLabel.isUserInteractionEnabled = true
        
        invButton.addChild(powerUpLabel)
    }
    
    //Set Up the Invincibility Button Particles
    func createInvParticle()
    {
        invParticle = SKEmitterNode(fileNamed: "invStar.sks")
        invParticle.position = CGPoint(x: 1334, y: 206)
        invParticle.zPosition = 45
        invParticle.particleBirthRate = 0.0
        addChild(invParticle)
    }
    
    //Set Up the Score Text
    func createScore()
    {
        scoreLabel.fontColor = UIColor(red: 0.9843137255, green: 0.007843137255, blue: 0.02745098039, alpha: 1.0)
        scoreLabel.fontSize = 100
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        scoreLabel.position = CGPoint(x: 870.5, y: 1978)
        scoreLabel.zPosition = 110
        
        addChild(scoreLabel)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let add = SKAction.run
        {
            self.currentScore = self.currentScore + 1
        }
        let addBlocks = SKAction.sequence([wait, add])
        let repeatForever = SKAction.repeatForever(addBlocks)
        scoreLabel.run(repeatForever)
    }
    
    //Method to Create Heart 1
    func createHeart1()
    {
        //Set up the Texture and Position for the 1st Heart Sprite
        let heartTexture = SKTexture(imageNamed: "heart")
        heart1 = SKSpriteNode(texture: heartTexture)
        heart1.position = CGPoint(x: 100, y: 1970)
        heart1.setScale(1.7)
        heart1.zPosition = 110
        
        //Add Heart 1 to the Game
        addChild(heart1)
    }
    
    //Method to Create Heart 2
    func createHeart2()
    {
        //Set up the Texture and Position for the 2nd Heart Sprite
        let heartTexture = SKTexture(imageNamed: "heart")
        heart2 = SKSpriteNode(texture: heartTexture)
        heart2.position = CGPoint(x: 212, y: 1970)
        heart2.setScale(1.7)
        heart2.zPosition = 110
        
        //Add Heart 2 to the Game
        addChild(heart2)
    }
    
    //Method to Create Heart 3
    func createHeart3()
    {
        //Set up the Texture and Position for the 3rd Heart Sprite
        let heartTexture = SKTexture(imageNamed: "heart")
        heart3 = SKSpriteNode(texture: heartTexture)
        heart3.position = CGPoint(x: 324, y: 1970)
        heart3.setScale(1.7)
        heart3.zPosition = 110
        
        //Add Heart 3 to the Game
        addChild(heart3)
    }
    
    //Set Up the Camera
    func createCamera()
    {
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam!)
    }
    
    //Set up the Camera Rectangle
    var cameraRect : CGRect
    {
        let x = (camera?.position.x)! - size.width/2
            + (size.width - playableRect.width)/2
        let y = (camera?.position.y)! - size.height/2
            + (size.height - playableRect.height)/2
        return CGRect(
            x: x,
            y: y,
            width: playableRect.width,
            height: playableRect.height)
    }
    
    
    
    ////Movement Methods
    //Set Up the Houses Movement
    func moveHouses()
    {
        switch Int.random(min: 1, max: 4)
        {
        case 1:
            if canSpawn1 == true
            {
                canSpawn1 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn1 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house1.run(moveLoop)
            }
            else if canSpawn2 == true
            {
                canSpawn2 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn2 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house2.run(moveLoop)
            }
            else if canSpawn3 == true
            {
                canSpawn3 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn3 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house3.run(moveLoop)
            }
            else if canSpawn4 == true
            {
                canSpawn4 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn4 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house4.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house.run(moveLoop)
            }
        case 2:
            if canSpawn2 == true
            {
                canSpawn2 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn2 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house2.run(moveLoop)
            }
            else if canSpawn1 == true
            {
                canSpawn1 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn1 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house1.run(moveLoop)
            }
            else if canSpawn3 == true
            {
                canSpawn3 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn3 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house3.run(moveLoop)
            }
            else if canSpawn4 == true
            {
                canSpawn4 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn4 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house4.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house.run(moveLoop)
            }
        case 3:
            if canSpawn3 == true
            {
                canSpawn3 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn3 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house3.run(moveLoop)
            }
            else if canSpawn1 == true
            {
                canSpawn1 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn1 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house1.run(moveLoop)
            }
            else if canSpawn2 == true
            {
                canSpawn2 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn2 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house2.run(moveLoop)
            }
            else if canSpawn4 == true
            {
                canSpawn4 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn4 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house4.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house.run(moveLoop)
            }
        case 4:
            if canSpawn4 == true
            {
                canSpawn4 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn4 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house4.run(moveLoop)
            }
            else if canSpawn1 == true
            {
                canSpawn1 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn1 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house1.run(moveLoop)
            }
            else if canSpawn2 == true
            {
                canSpawn2 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn2 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house2.run(moveLoop)
            }
            else if canSpawn3 == true
            {
                canSpawn3 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn3 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house3.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house.run(moveLoop)
            }
        default:
            if canSpawn1 == true
            {
                canSpawn1 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn1 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house1.run(moveLoop)
            }
            else if canSpawn2 == true
            {
                canSpawn2 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn2 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house2.run(moveLoop)
            }
            else if canSpawn3 == true
            {
                canSpawn3 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn3 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house3.run(moveLoop)
            }
            else if canSpawn4 == true
            {
                canSpawn4 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn4 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house4.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house.run(moveLoop)
            }
        }
        
        switch Int.random(min: 5, max: 8)
        {
        case 5:
            if canSpawn5 == true
            {
                canSpawn5 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn5 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house5.run(moveLoop)
            }
            else if canSpawn6 == true
            {
                canSpawn6 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn6 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house6.run(moveLoop)
            }
            else if canSpawn7 == true
            {
                canSpawn7 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn7 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house7.run(moveLoop)
            }
            else if canSpawn8 == true
            {
                canSpawn8 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn8 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house8.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house0.run(moveLoop)
            }
        case 6:
            if canSpawn6 == true
            {
                canSpawn6 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn6 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house6.run(moveLoop)
            }
            else if canSpawn5 == true
            {
                canSpawn5 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn5 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house5.run(moveLoop)
            }
            else if canSpawn7 == true
            {
                canSpawn7 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn7 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house7.run(moveLoop)
            }
            else if canSpawn8 == true
            {
                canSpawn8 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn8 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house8.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house0.run(moveLoop)
            }
        case 7:
            if canSpawn7 == true
            {
                canSpawn7 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn7 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house7.run(moveLoop)
            }
            else if canSpawn5 == true
            {
                canSpawn5 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn5 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house5.run(moveLoop)
            }
            else if canSpawn6 == true
            {
                canSpawn6 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn6 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house6.run(moveLoop)
            }
            else if canSpawn8 == true
            {
                canSpawn8 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn8 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house8.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house0.run(moveLoop)
            }
        case 8:
            if canSpawn8 == true
            {
                canSpawn8 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn8 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house8.run(moveLoop)
            }
            else if canSpawn5 == true
            {
                canSpawn5 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn5 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house5.run(moveLoop)
            }
            else if canSpawn6 == true
            {
                canSpawn6 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn6 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house6.run(moveLoop)
            }
            else if canSpawn7 == true
            {
                canSpawn7 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn7 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house7.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house0.run(moveLoop)
            }
        default:
            if canSpawn8 == true
            {
                canSpawn8 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn8 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house8.run(moveLoop)
            }
            else if canSpawn5 == true
            {
                canSpawn5 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn5 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house5.run(moveLoop)
            }
            else if canSpawn6 == true
            {
                canSpawn6 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn6 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house6.run(moveLoop)
            }
            else if canSpawn7 == true
            {
                canSpawn7 = false
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let canSpawn = SKAction.run
                {
                    self.canSpawn7 = true
                }
                let moveLoop = SKAction.sequence([moveDown, reset, canSpawn])
                house7.run(moveLoop)
            }
            else
            {
                let moveDown = SKAction.moveTo(y: -1000, duration: 4.9)
                let reset = SKAction.moveTo(y: 2468, duration: 0)
                let moveLoop = SKAction.sequence([moveDown, reset])
                house0.run(moveLoop)
            }
        }
    }
    
    //Set Up the Cat Movement
    func moveCat()
    {
        let randomCatLoc = CGFloat.random(min: 1221, max: 2000)
        let catStartLoc = CGPoint(x: -171, y: randomCatLoc)
        let moveDown = SKAction.move(to: catMove, duration: 2.5)
        let remove = SKAction.move(to: catStartLoc, duration: 0)
        let catSpawnSwitch = SKAction.run
        {
            self.canSpawnCat = true
        }
        let fullMove = SKAction.sequence([moveDown, remove, catSpawnSwitch])
        cat.run(fullMove)
    }
    
    //Set Up the Left Car Movement
    func moveLeftCar()
    {
        let carLeftStartLoc = CGPoint(x: 276, y: 2292)
        let carLeftMove = CGPoint(x: (carLeft.position.x) + cos(carLeft.zRotation) * 1600, y: (carLeft.position.y) + sin(carLeft.zRotation) * -3500)
        
        let moveDown = SKAction.move(to: carLeftMove, duration: 2.5)
        let remove = SKAction.move(to: carLeftStartLoc, duration: 0)
        let carSpawnSwitch = SKAction.run
        {
            self.sirenPlayer.stop()
            self.sirenPlayer.currentTime = 0.7
            self.canSpawnCar = true
        }
        let fullMove = SKAction.sequence([moveDown, remove, carSpawnSwitch])
        carLeft.run(fullMove)
    }
    
    //Set Up the Right Car Movement
    func moveRightCar()
    {
        let carRightStartLoc = CGPoint(x: 1260, y: 2292)
        let carRightMove = CGPoint(x: (carRight.position.x) + cos(carRight.zRotation) * -1600, y: (carRight.position.y) + sin(carRight.zRotation) * 3500)
        
        let moveDown = SKAction.move(to: carRightMove, duration: 2.5)
        let remove = SKAction.move(to: carRightStartLoc, duration: 0)
        let carSpawnSwitch = SKAction.run
        {
            self.sirenPlayer.stop()
            self.sirenPlayer.currentTime = 0.7
            self.canSpawnCar = true
        }
        let fullMove = SKAction.sequence([moveDown, remove, carSpawnSwitch])
        carRight.run(fullMove)
    }
    
    //Set Up the Bone Movement
    func moveBone()
    {
        let boneRandomLoc = CGPoint(x: CGFloat.random(min: 441.8, max: 1094.8), y: 2100)
        
        if collectablesOnScreen < 1
        {
            collectablesOnScreen = collectablesOnScreen + 1
            
            let appear = SKAction.scale(to: 0.8, duration: 0.5)
            
            let scaleUp = SKAction.scale(by: 1.2, duration: 0.2)
            let scaleDown = scaleUp.reversed()
            let rotateUp = SKAction.rotate(toAngle: 0.523599, duration: 0.5)
            let rotateDown = SKAction.rotate(toAngle: -0.523599, duration: 0.5)
            let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
            let fullRotate = SKAction.sequence([rotateUp, rotateDown, rotateUp, rotateDown])
            let group = SKAction.group([fullScale, fullRotate])
            let groupWait = SKAction.repeat(group, count: 10)
            let subtractCollectables = SKAction.run
            {
                self.collectablesOnScreen = self.collectablesOnScreen - 1
            }
            let disappear = SKAction.scale(to: 0, duration: 0.5)
            let actions = [appear, groupWait, disappear, subtractCollectables]
            bone.run(SKAction.sequence(actions))
            
            let moveDown = SKAction.moveTo(y: -300, duration: 4.0)
            let resetPos = SKAction.move(to: boneRandomLoc, duration: 0)
            let sequence = SKAction.sequence([moveDown, resetPos])
            bone.run(sequence)
        }
    }
    
    
    
    ////Start Methods
    //Method to Start Ferris Running Animation
    func startFerrisAnimation()
    {
        if ferris.action(forKey: "animation") == nil
        {
            ferris.run(
                //Repeat the animated sprites forever.
                SKAction.repeatForever(ferrisAnimation),
                withKey: "animation")
        }
    }
    
    //Method to Start Moving the Houses
    func startHouses()
    {
        let create = SKAction.run
        {
            [unowned self] in
            self.moveHouses()
        }
        let wait = SKAction.wait(forDuration: 1.2)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        speedParent.run(repeatForever)
        wait.speed = 0.5
    }
    
    //Method to Start the Cat Animation
    func startCatAnimation()
    {
        if cat.action(forKey: "animation") == nil
        {
            cat.run(
                //Repeat the animated sprites forever.
                SKAction.repeatForever(catAnimation),
                withKey: "animation")
        }
    }
    
    //Method to Start the Police Car Animation
    func startCarAnimation()
    {
        if carLeft.action(forKey: "animation") == nil
        {
            carLeft.run(
                //Repeat the animated sprites forever.
                SKAction.repeatForever(carAnimation),
                withKey: "animation")
        }
        
        if carRight.action(forKey: "animation") == nil
        {
            carRight.run(
                //Repeat the animated sprites forever.
                SKAction.repeatForever(carAnimation),
                withKey: "animation")
        }
    }
    
    //Method to Reset the Position of the Bone After it has been Collected
    func resetBone()
    {
        let boneRandomLoc = CGPoint(x: CGFloat.random(min: 441.8, max: 1094.8), y: 2100)
        let wait = SKAction.wait(forDuration: 0.1)
        let addPU = SKAction.run
        {
            self.bonesCollected = self.bonesCollected + 1
            self.collectablesOnScreen = self.collectablesOnScreen - 1
            self.bonePopPlayer.play()
            self.bone.removeAllActions()
            self.bone.position = boneRandomLoc
        }
        let sequence = SKAction.sequence([wait, addPU])
        bone.run(sequence)
    }
    
    //Method to Start Ferris being Invincible
    func activateInvincibility()
    {
        invParticle.particleBirthRate = 0.0
        bonesCollected = 0
        invinciblePU = true
        invVolumeUp()
        let wait = SKAction.wait(forDuration: 10)
        let changeInv = SKAction.run
        {
            self.invinciblePU = false
        }
        let resetColor = SKAction.colorize(with: SKColor.black, colorBlendFactor: 0.0, duration: 0)
        let ferrisResetColor = SKAction.run
        {
            self.ferris.run(resetColor)
            self.invVolumeDown()
        }
        let invSequence = SKAction.sequence([wait, ferrisResetColor, changeInv])
        
        run(invSequence)
    }
    
    
    
    ////Randomize Methods
    //Method to Randomize the Cat Spawning and Start its Movement
    func randomizeCatSpawn(forUpdate currentTime: CFTimeInterval)
    {
        let i = Int.random(min: 5, max: 20)
        
        if canSpawnCat == true
        {
            canSpawnCat = false
            let wait = SKAction.wait(forDuration: TimeInterval(i))
            let spawnCat = SKAction.run
            {
                self.meowPlayer.play()
                self.moveCat()
            }
            let fullSequence = SKAction.sequence([wait, spawnCat])
            run(fullSequence)
        }
    }
    
    //Method to Randomize the Car Spawning and Start its Movement
    func randomizeCarSpawn(forUpdate currentTime: CFTimeInterval)
    {
        let i = Int.random(min: 5, max: 20)
        
        if canSpawnCar == true
        {
            switch Int.random(min: 0, max: 1)
            {
            case 0:
                canSpawnCar = false
                let wait = SKAction.wait(forDuration: TimeInterval(i))
                let spawnCat = SKAction.run
                {
                    self.sirenPlayer.play()
                    self.moveLeftCar()
                }
                let fullSequence = SKAction.sequence([wait, spawnCat])
                run(fullSequence)
            case 1:
                canSpawnCar = false
                let wait = SKAction.wait(forDuration: TimeInterval(i))
                let spawnCat = SKAction.run
                {
                    self.sirenPlayer.play()
                    self.moveRightCar()
                }
                let fullSequence = SKAction.sequence([wait, spawnCat])
                run(fullSequence)
            default:
                canSpawnCar = false
                let wait = SKAction.wait(forDuration: TimeInterval(i))
                let spawnCat = SKAction.run
                {
                    self.moveLeftCar()
                }
                let fullSequence = SKAction.sequence([wait, spawnCat])
                run(fullSequence)
            }
        }
    }
    
    //Method to Randomize the Bone Spawning and Start its Movement
    func randomCollectableSpawner(forUpdate currentTime: CFTimeInterval)
    {
        let collectablePercentage = Int.random(min: 1, max: 100)
        
        if Int.random(min: 1, max: 100) >= collectablePercentage
        {
            if collectablePercentage >= 96 && collectablesOnScreen < 1 && bonesCollected < 3 && invinciblePU == false
            {
                moveBone()
            }
        }
    }
    
    //Method to Randomize Ferris Barking
    func randomizeBark(forUpdate currentTime: CFTimeInterval)
    {
        let randomBark = Int.random(min: 0, max: 100)
        
        if randomBark <= 1 && canBark == true
        {
            print("canBark")
            switch Int.random(min: 0, max: 10)
            {
            case 0:
                canBark = false
                barkPlayer.play()
            case 1:
                print("No Bark")
            case 2:
                print("No Bark")
            case 3:
                print("No Bark")
            case 4:
                print("No Bark")
            case 5:
                print("No Bark")
            case 6:
                print("No Bark")
            case 7:
                print("No Bark")
            case 8:
                print("No Bark")
            case 9:
                print("No Bark")
            case 10:
                print("No Bark")
            default:
                print("No Bark")
            }
        }
    }
    
    
    
    ////Change Methods
    //Method to Increase the Game Speed Every 30 Seconds
    func changeSpeeds()
    {
        let wait = SKAction.wait(forDuration: 30.0)
        let changeSpeed = SKAction.run
        {
            self.speedParent.speed = self.speedParent.speed + 0.1
            self.catAnimation.speed = 0.5
            self.carAnimation.speed = 0.5
        }
        let speedSequence = SKAction.sequence([wait, changeSpeed])
        let repeatForever = SKAction.repeatForever(speedSequence)
        speedParent.run(repeatForever)
    }
    
    //Method to Fade In Invincibility Music and Fade Out the Background Music
    func invVolumeUp()
    {
        invPlayer.setVolume(0.02, fadeDuration: 0.5)
        backgroundPlayer.setVolume(0.0, fadeDuration: 0.5)
    }
    
    //Method to Fade Out Invincibility Music and Fade In the Background Music
    func invVolumeDown()
    {
        invPlayer.setVolume(0.0, fadeDuration: 0.5)
        backgroundPlayer.setVolume(0.02, fadeDuration: 0.5)
    }
    
    
    
    ////Destroy Methods
    //Method to Destroy Lives and Switch to Either the Game Over Scene or the Win Scene
    func destroyLives()
    {
        if lives == 2
        {
            heart3.removeFromParent()
        }
        if lives == 1
        {
            heart2.removeFromParent()
        }
        if lives == 0 && currentScore < 200
        {
            let decreaseSpeed = SKAction.speed(to: 0, duration: 1.5)
            speedParent.run(decreaseSpeed)
            meowPlayer.stop()
            sirenPlayer.stop()
            let highScoreDefaults = UserDefaults.standard
            highScoreDefaults.set(highScore, forKey : "highScore")
            let currentScoreDefaults = UserDefaults.standard
            currentScoreDefaults.set(currentScore, forKey : "currentScore")
            scoreLabel.removeAllActions()
            heart1.removeFromParent()
            ferris.removeFromParent()
            backgroundPlayer.setVolume(0.0, fadeDuration: 3.0)
            invPlayer.setVolume(0.0, fadeDuration: 3.0)
            runningPlayer.setVolume(0.0, fadeDuration: 3.0)
            let wait = SKAction.wait(forDuration: 3.0)
            let block = SKAction.run
            {
                self.backgroundPlayer.stop()
                self.invPlayer.stop()
                self.runningPlayer.stop()
                let myScene = GameOverScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                self.view?.presentScene(myScene)
            }
            self.run(SKAction.sequence([wait, block]))
        }
        if lives == 0 && currentScore >= 200
        {
            let decreaseSpeed = SKAction.speed(to: 0, duration: 1.5)
            speedParent.run(decreaseSpeed)
            meowPlayer.stop()
            sirenPlayer.stop()
            let highScoreDefaults = UserDefaults.standard
            highScoreDefaults.set(highScore, forKey : "highScore")
            let currentScoreDefaults = UserDefaults.standard
            currentScoreDefaults.set(currentScore, forKey : "currentScore")
            scoreLabel.removeAllActions()
            heart1.removeFromParent()
            ferris.removeFromParent()
            backgroundPlayer.setVolume(0.0, fadeDuration: 3.0)
            invPlayer.setVolume(0.0, fadeDuration: 3.0)
            runningPlayer.setVolume(0.0, fadeDuration: 3.0)
            let wait = SKAction.wait(forDuration: 3.0)
            let block = SKAction.run
            {
                self.backgroundPlayer.stop()
                self.invPlayer.stop()
                self.runningPlayer.stop()
                let myScene = WinScene(size: self.size)
                myScene.scaleMode = self.scaleMode
                self.view?.presentScene(myScene)
            }
            self.run(SKAction.sequence([wait, block]))
        }
    }
}
