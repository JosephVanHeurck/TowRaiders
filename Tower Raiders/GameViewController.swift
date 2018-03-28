//
//  GameViewController.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 24/3/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var attackBtn: UIButton!
    
    // Load the SKScene from 'GameScene.sks'
    var scene = CombatScene(fileNamed: "GameScene")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            // Set the scale mode to scale to fit the window
                
            scene.scaleMode = .aspectFill
                
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func attackActionSelected(_ sender: UIButton) {
        scene.setAction(type: .attack, name: "none", target: 3)
    }
    
    @IBAction func abilityActionSelected(_ sender: UIButton) {
        //scene.setAction(type: .ability, name: "none")
    }
    
    @IBAction func defendActionSelected(_ sender: UIButton) {
        //scene.setAction(type: .defend, name: "none")
    }
    
    @IBAction func swapActionSelected(_ sender: UIButton) {
        //scene.setAction(type: .swap, name: "none")
    }
}
