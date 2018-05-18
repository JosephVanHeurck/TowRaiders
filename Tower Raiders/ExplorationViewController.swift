//
//  ExplorationViewController.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 26/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ExplorationViewController: UIViewController {

    // Load the SKScene from 'ExplorationScene.sks'
    var scene = ExplorationScene(fileNamed: "ExplorationScene")!
    var firstAppearance = true
    
    @IBAction func NextAction(_ sender: UIButton) {
        scene.moveToNextStep()
        /*
        while !scene.eventReady {
            scene.eventReady = false
            switch scene.eventType {
            case .none:
                break
            case .treasure:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Event", bundle:nil)
                
                let eventViewController = storyBoard.instantiateViewController(withIdentifier: "EventScreen") as! EventViewController
                self.present(eventViewController, animated:true, completion:nil)
            case .end:
                break
            default:
                break
            }
        }*/
    }
    
    func goToEventScreen() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Event", bundle:nil)
        
        let eventViewController = storyBoard.instantiateViewController(withIdentifier: "EventScreen") as! EventViewController
        self.present(eventViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance {
            if let view = self.view as! SKView? {
                // Set the scale mode to scale to fit the window
                
                scene.scaleMode = .aspectFill
                scene.parentViewController = self
                
                // Present the scene
                view.presentScene(scene)
                
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                firstAppearance = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
