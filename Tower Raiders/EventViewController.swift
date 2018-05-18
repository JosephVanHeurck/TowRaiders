//
//  EventViewController.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 27/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import UIKit
import SpriteKit

class EventViewController: UIViewController {
    
    var scene = EventScene(fileNamed: "EventScene")!
    
    var eventType: placeEvent?
    
    var clicks = 0
    
    @IBOutlet weak var Lbl: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var text: UILabel!
    
    var scribe = Scribe()
    var currentScript: [String: String]!
    var background: String!
    var presence: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        text.numberOfLines = 3
        
        // Do any additional setup after loading the view.
        if eventType == .treasure {
            Lbl.text = "Treasure Event"
        }
        else if eventType == .end {
            Lbl.text = "END"
        }
        else {
            eventType = .none
        }
        
        loadEventData()
        
        if let view = self.view as! SKView? {
            // Set the scale mode to scale to fit the window
            
            scene.scaleMode = .aspectFill
            scene.parentViewController = self
            
            scene.presence = presence
            scene.background = background
            
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func loadEventData() {
        scribe.read("Route")
        scribe.read("EventInfo")
        scribe.read("Script")
        
        let index = scribe.route[0]["CurrentStepID"]
        var event: String!
        var id: String!
        
        for r in scribe.route {
            if r["ID"] == index {
                background = r["Background"]
                event = r["PlaceType"]
            }
        }
        
        for p in scribe.eventInfo {
            if p["Event Type"] == event {
                presence = p["Presence"]
                id = p["Script Start ID"]
            }
        }
        
        loadScript(id: id)
    }
    
    func loadScript(id: String) {
        // loads new script
        for s in scribe.script {
            if s["Script ID"] == id {
                currentScript = s
            }
        }
        
        text.text = currentScript["Text"]
        
        option1.isHidden = true
        option2.isHidden = true
        
        if currentScript["Type"] == "Option" {
            option1.setTitle(currentScript["Option 1"], for: .normal)
            option2.setTitle(currentScript["Option 2"], for: .normal)
            option1.isHidden = false
            option2.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        clicks += 1
        Lbl.text = "text pressed " + String(clicks)
        // self.dismiss(animated: true, completion: nil)
        processNext(with: "Touch")
    }
    
    func processNext(with: String) {
        var type = currentScript["Type"]!
        var id: String!
        switch type {
        case "Next":
            id = String(Int(currentScript["Script ID"]!)! + 1)
        case "Option":
            switch with {
            case "Touch":
                return
            case "Option1":
                id = currentScript["Option 1 Script ID"]
            case "Option2":
                id = currentScript["Option 2 Script ID"]
            default:
                break
            }
        case "Random":
            let result = arc4random() % 2
            if result == 0 {
                id = currentScript["Option 1 Script ID"]
            }
            else {
                id = currentScript["Option 2 Script ID"]
            }
        case "End":
            self.dismiss(animated: true, completion: nil)
            return
        default:
            break
        }
        
        loadScript(id: id)
    }
    
    @IBAction func button1(_ sender: UIButton) {
        processNext(with: "Option1")
    }
    
    @IBAction func button2(_ sender: UIButton) {
        processNext(with: "Option2")
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
