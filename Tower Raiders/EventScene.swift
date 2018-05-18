//
//  EventScene.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 17/5/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import Foundation
import SpriteKit

class EventScene : SKScene {
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var backgroundNode = SKSpriteNode()
    var playerNode = SKSpriteNode()
    var presenceNode = SKSpriteNode()
    
    var parentViewController: UIViewController!
    var presence: String!
    var background: String!
    
    override func didMove(to view: SKView) {
        backgroundNode = self.childNode(withName: "Background") as! SKSpriteNode
        playerNode = self.childNode(withName: "Player") as! SKSpriteNode
        presenceNode = self.childNode(withName: "Presence") as! SKSpriteNode
        
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        screenWidth = appDelegate.window?.bounds.width
        screenHeight = appDelegate.window?.bounds.height
        
        backgroundNode.zPosition = 1
        playerNode.zPosition = 2
        presenceNode.zPosition = 2
        
        var playerTex = SKTexture(imageNamed: "idleKnight")
        playerNode.texture = playerTex
        playerNode.size = playerTex.size()
        playerNode.size.height = playerNode.size.height * 240 / screenHeight
        playerNode.size.width = playerNode.size.width * 240 / screenHeight
        
        if presence == "none" {
            presenceNode.isHidden = true
        }
        
        var presenceTex = SKTexture(imageNamed: presence)
        presenceNode.texture = presenceTex
        presenceNode.size = presenceTex.size()
        presenceNode.size.height = presenceNode.size.height * 240 / screenHeight
        presenceNode.size.width = presenceNode.size.width * 240 / screenHeight
        
        var backgroundTex = SKTexture(imageNamed: background)
        backgroundNode.texture = backgroundTex
        backgroundNode.size = backgroundTex.size()
        
        let scaleFromBackground = screenWidth/backgroundNode.size.width
        
        var size = CGSize(width: screenWidth, height: backgroundTex.size().height * scaleFromBackground)
        backgroundNode.size = size
        backgroundNode.position.y = (backgroundNode.size.height - screenHeight) / 2
    }
}
