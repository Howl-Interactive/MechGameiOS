//
//  UI.swift
//  MechGameWorkspace
//
//  Created by Jacob Macdonald on 4/26/15.
//  Copyright (c) 2015 HowlInteractive. All rights reserved.
//

import SpriteKit

class UI : SKNode {
    
    var pauseButton = Button(x: WIDTH - 20, y: HEIGHT - 20, w: 20, h: 20, file: "pause.png", onClick: { gameScene.togglePause() })
    var pauseScreen = PauseScreen()
    var endScreen = EndScreen()
    var logoScreen = LogoScreen()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        zPosition = 10000
        pauseButton.zPosition = 1
        addChild(pauseButton)
        logoScreen.zPosition = 2
        addChild(logoScreen)
    }
}

class Button : SKSpriteNode {
    
    var image, alternate: String
    var onClick: ()->()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x: CGFloat, y: CGFloat, w: CGFloat? = nil, h: CGFloat? = nil, file: String, alternate: String = "", onClick: ()->()) {
        self.image = file
        self.alternate = alternate
        self.onClick = onClick
        var texture = SKTexture(imageNamed: file)
        super.init(texture: texture, color: nil, size: texture.size())
        userInteractionEnabled = true
        position = CGPoint(x: x, y: y)
        if let width = w, height = h {
            size = CGSize(width: width, height: height)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        onClick()
        gameScene.buttonActivated = true
    }
    
    func toggleImage() {
        texture = SKTexture(imageNamed: alternate)
        var temp = image
        image = alternate
        alternate = temp
    }
}

class AnimatedText : SKLabelNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x: CGFloat, y: CGFloat, text: String) {
        super.init()
        self.text = text
        position = CGPoint(x: x, y: y)
        fontSize = 16
        fontName = "HelveticaNeue"
        runAction(
            SKAction.customActionWithDuration(
                1, actionBlock: { (node: SKNode!, timeElapsed: CGFloat) in
                    self.fontColor = COLORS[Int(arc4random_uniform(UInt32(COLORS.count)))]
                }
            ), completion: {
                self.removeFromParent()
            }
        )
    }
}

class PauseScreen : SKNode {
    
    var pausedText = SKSpriteNode(imageNamed: "paused_text.png")
    var quitText = SKSpriteNode(imageNamed: "quit_button.png")
    var musicText = SKSpriteNode(imageNamed: "music_text.png")
    var sfxText = SKSpriteNode(imageNamed: "sfx_text.png")
    var onOffButtonMusic = Button(x: WIDTH / 2, y: HEIGHT - 305, file: "onoff_buttonON.png", alternate: "onoff_buttonOFF.png", onClick: { })
    var onOffButtonSFX = Button(x: WIDTH / 2, y: HEIGHT - 425, file: "onoff_buttonON.png", alternate: "onoff_buttonOFF.png", onClick: { })
    var foreground = SKSpriteNode(imageNamed: "above_buildings.png")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        pausedText.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 100)
        if let textureSize: CGSize = pausedText.texture?.size() {
            let aspectRatio = textureSize.width / textureSize.height
            pausedText.size = CGSize(width: WIDTH / 4 * 3, height: ceil(WIDTH / 4 * 3 / aspectRatio))
        }
        addChild(pausedText)
        var height: CGFloat = 40
        musicText.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 255)
        if let textureSize: CGSize = musicText.texture?.size() {
            let aspectRatio = textureSize.height / textureSize.width
            musicText.size = CGSize(width: ceil(height / aspectRatio), height: height)
        }
        //addChild(musicText)
        sfxText.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 375)
        if let textureSize: CGSize = sfxText.texture?.size() {
            let aspectRatio = textureSize.height / textureSize.width
            sfxText.size = CGSize(width: ceil(height / aspectRatio), height: height)
        }
        addChild(sfxText)
        quitText.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 495)
        if let textureSize: CGSize = quitText.texture?.size() {
            let aspectRatio = textureSize.height / textureSize.width
            quitText.size = CGSize(width: ceil(height / aspectRatio), height: height)
        }
        //addChild(quitText)
        height = 25
        onOffButtonMusic.onClick = { audioController.toggleMusic(); self.onOffButtonMusic.toggleImage() }
        if let textureSize: CGSize = onOffButtonMusic.texture?.size() {
            let aspectRatio = textureSize.height / textureSize.width
            onOffButtonMusic.size = CGSize(width: ceil(height / aspectRatio), height: height)
        }
        //addChild(onOffButtonMusic)
        onOffButtonSFX.onClick = { audioController.toggleSFX(); self.onOffButtonSFX.toggleImage() }
        if let textureSize: CGSize = onOffButtonSFX.texture?.size() {
            let aspectRatio = textureSize.height / textureSize.width
            onOffButtonSFX.size = CGSize(width: ceil(height / aspectRatio), height: height)
        }
        addChild(onOffButtonSFX)
        foreground.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        foreground.size = CGSize(width: WIDTH, height: HEIGHT)
        foreground.zPosition = -1
        addChild(foreground)
    }
}

class EndScreen : SKNode {
    
    var title = Title(x: WIDTH / 2, y: HEIGHT - 75)
    var foreground = SKSpriteNode(imageNamed: "above_buildings.png")
    var gameOverText = SKLabelNode(fontNamed: "Visitor TT1 BRK")
    var buildingSprite = SKSpriteNode(imageNamed: "building01.png")
    var buildingScore = SKLabelNode(fontNamed: "Visitor TT1 BRK")
    var enemySprite = SKSpriteNode(imageNamed: "enemy00.png")
    var enemyScore = SKLabelNode(fontNamed: "Visitor TT1 BRK")
    var score = SKLabelNode(fontNamed: "Visitor TT1 BRK")
    var launchButton = Button(x: WIDTH / 2, y: HEIGHT - 500, file: "launch_button.png", onClick: { })
    var blackScreen = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: WIDTH, height: HEIGHT))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        foreground.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        foreground.size = CGSize(width: WIDTH, height: HEIGHT)
        foreground.zPosition = -1
        addChild(foreground)
        title.zPosition = 2
        addChild(title)
        blackScreen.zPosition = 1
        blackScreen.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        addChild(blackScreen)
        gameOverText.text = "Game Over"
        gameOverText.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 200)
        buildingSprite.position = CGPoint(x: WIDTH / 2 - 50, y: HEIGHT - 275)
        buildingSprite.xScale = 0.2
        buildingSprite.yScale = 0.2
        buildingSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        buildingScore.text = "x \(buildingsDestroyed) ..... \(buildingsDestroyed * buildingValue)"
        buildingScore.fontSize = 16
        buildingScore.position = CGPoint(x: WIDTH / 2 - 33, y: HEIGHT - 275)
        buildingScore.horizontalAlignmentMode = .Left
        enemySprite.position = CGPoint(x: WIDTH / 2 - 50, y: HEIGHT - 325)
        enemySprite.xScale = 0.4
        enemySprite.yScale = 0.4
        enemySprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        enemyScore.text = "x \(enemiesDestroyed) ..... \(enemiesDestroyed * enemyValue)"
        enemyScore.fontSize = 16
        enemyScore.position = CGPoint(x: WIDTH / 2 - 33, y: HEIGHT - 325)
        enemyScore.horizontalAlignmentMode = .Left
        score.text = "Score: \(buildingsDestroyed * buildingValue + enemiesDestroyed * enemyValue)"
        score.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 400)
        launchButton.onClick = { self.removeFromParent(); gameScene.reset(); self.turnOff() }
        addChild(gameOverText)
        addChild(buildingSprite)
        addChild(buildingScore)
        addChild(enemySprite)
        addChild(enemyScore)
        addChild(score)
        addChild(launchButton)
        gameScene.background.colorBlendFactor = 0
        for obj in gameScene.objs {
            if obj is Road {
                obj.sprite.runAction(SKAction.hide())
            }
        }
    }
    
    func turnOn() {
        gameScene.background.colorBlendFactor = 0
        for obj in gameScene.objs {
            if obj is Road {
                obj.sprite.runAction(SKAction.hide())
            }
        }
        blackScreen.zPosition = 1
        blackScreen.runAction(SKAction.fadeAlphaTo(1, duration: 1), completion: {
            self.title = Title(x: WIDTH / 2, y: HEIGHT - 75)
            self.title.beginAnimation()
            self.title.zPosition = 2
            self.addChild(self.title)
            self.addChild(self.gameOverText)
            self.addChild(self.buildingSprite)
            self.addChild(self.buildingScore)
            self.addChild(self.enemySprite)
            self.addChild(self.enemyScore)
            self.addChild(self.score)
            self.addChild(self.launchButton)
        })
        gameOverText.removeFromParent()
        buildingSprite.removeFromParent()
        buildingScore.removeFromParent()
        enemySprite.removeFromParent()
        enemyScore.removeFromParent()
        score.removeFromParent()
        launchButton.removeFromParent()
        title.removeFromParent()
        buildingScore.text = "x \(buildingsDestroyed) ..... \(buildingsDestroyed * buildingValue)"
        enemyScore.text = "x \(enemiesDestroyed) ..... \(enemiesDestroyed * enemyValue)"
        score.text = "Score: \(buildingsDestroyed * buildingValue + enemiesDestroyed * enemyValue)"
    }
    
    func turnOff() {
        gameScene.background.colorBlendFactor = 1
        for obj in gameScene.objs {
            if obj is Road {
                obj.sprite.runAction(SKAction.unhide())
            }
        }
    }
}

class Title : SKSpriteNode {
    
    var counter = 1
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x: CGFloat, y: CGFloat) {
        let t = SKTexture(imageNamed: "title_1.png")
        super.init(texture: t, color: nil, size: t.size())
        position = CGPoint(x: x, y: y)
    }
    
    func beginAnimation() {
        runAction(SKAction.repeatAction(SKAction.customActionWithDuration(0.1, actionBlock: {(SKNode, CGFloat) in
            if ++self.counter <= 29 {
                self.texture = SKTexture(imageNamed: "title_\(self.counter).png")
            }
            else if self.counter == 30 {
                ui.endScreen.blackScreen.runAction(SKAction.fadeOutWithDuration(1), completion: { ui.endScreen.blackScreen.zPosition = -1 })
            }
        }), count: 18))
    }
}

class LogoScreen : SKNode {
    
    var background = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: WIDTH, height: HEIGHT))
    var logo = Logo()
    var companyName = SKLabelNode(fontNamed: "Helvetica")
    var madeBy1 = SKLabelNode(fontNamed: "Helvetica")
    var madeBy2 = SKLabelNode(fontNamed: "Helvetica")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        background.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        background.zPosition = -1
        addChild(background)
        logo.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 200)
        addChild(logo)
        companyName.text = "Howl Interactive, Inc."
        companyName.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 350)
        companyName.fontColor = SKColor.blackColor()
        companyName.runAction(SKAction.fadeAlphaTo(0, duration: 0))
        addChild(companyName)
        madeBy1.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 400)
        madeBy1.text = "A game made by"
        madeBy1.fontColor = SKColor.blackColor()
        madeBy1.fontSize = 12
        madeBy1.runAction(SKAction.fadeAlphaTo(0, duration: 0))
        addChild(madeBy1)
        madeBy2.position = CGPoint(x: WIDTH / 2, y: HEIGHT - 415)
        madeBy2.text = "Jacob Macdonald and Rafael De Los Santos"
        madeBy2.fontColor = SKColor.blackColor()
        madeBy2.fontSize = 12
        madeBy2.runAction(SKAction.fadeAlphaTo(0, duration: 0))
        addChild(madeBy2)
    }
}

class Logo : SKSpriteNode {
    
    var counter = 1
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let t = SKTexture(imageNamed: "howl05_1.png")
        super.init(texture: t, color: nil, size: t.size())
        runAction(SKAction.repeatAction(SKAction.customActionWithDuration(0.1, actionBlock: {(SKNode, CGFloat) in
            if ++self.counter <= 32 {
                if self.counter == 2 {
                    audioController.play("fuckit.wav")
                }
                self.texture = SKTexture(imageNamed: "howl05_\(self.counter).png")
            }
            else if self.counter == 40 {
                ui.logoScreen.companyName.runAction(SKAction.fadeInWithDuration(0.5))
            }
            else if self.counter == 60 {
                ui.logoScreen.madeBy1.runAction(SKAction.fadeInWithDuration(0.5))
            }
            else if self.counter == 80 {
                ui.logoScreen.madeBy2.runAction(SKAction.fadeInWithDuration(0.5))
            }
            else if self.counter == 120 {
                ui.addChild(ui.endScreen)
                ui.logoScreen.runAction(SKAction.fadeOutWithDuration(1), completion: { ui.logoScreen.removeFromParent(); ui.endScreen.title.beginAnimation() })
            }
        }), count: 120))
    }
}