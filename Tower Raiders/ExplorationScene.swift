//
//  ExplorationScene.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 26/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import UIKit
import SpriteKit

enum placeEvent {
    case none
    case treasure
    case end
}


class ExplorationScene: SKScene {
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    var scaleFromMap: CGFloat!
    var mapNode = SKSpriteNode()
    var playerNode = SKSpriteNode()
    
    var playerPos = CGPoint()
    
    var routeIDs = [UInt]()
    var route = [CGPoint]()
    var currentStep = 0
    
    var moveFinished = true
    
    var eventReady = false
    var eventType: placeEvent = .none
    
    var scribe = Scribe()
    
    var cam = SKCameraNode()
    
    var parentViewController: UIViewController!
    
    override func didMove(to view: SKView) {
        parentViewController = self.view?.window?.rootViewController
        
        mapNode = self.childNode(withName: "Map") as! SKSpriteNode
        playerNode = self.childNode(withName: "Player") as! SKSpriteNode
        
        scribe.read(withName: "MapExplorationPlaces1")
        
        size = CGSize(width: screenWidth, height: screenHeight)
        
        camera = cam
        scaleFromMap = size.height/mapNode.size.height
        
        let newMapWidth = mapNode.size.width * scaleFromMap
        mapNode.size.width = newMapWidth
        mapNode.size.height = screenHeight
        mapNode.zPosition = 2
        
        playerNode.size.width *= scaleFromMap
        playerNode.size.height *= scaleFromMap
        playerNode.position = translatePositionFromRaw(x: 420, y: 845)
        playerNode.zPosition = 3
        
        
        // createRoute has a small chance of an unfixable (as far as google can tell) crash
        // EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
        // thus if it occurs, the function will be abandoned and restarted
        // although this now doesn't fix the error
        var done = false
        while !done {
            do {
                done = try createRoute(9)
            }
            catch {
                
            }
        }
        
        
        
    }
    
    func moveToNextStep() -> Void {
        if moveFinished {
            moveFinished = false
            currentStep += 1
            
            var move = SKAction.move(to: translatePositionFromRaw(pos: route[currentStep]), duration: 1)
            var setFinished = SKAction.run {
                self.moveFinished = true
                /*if self.scribe.map[Int(self.routeIDs[self.currentStep])]["PlaceType"]! == "EVENT_TREASURE" {
                    self.eventReady = true
                    self.eventType = .treasure
                    //self.parentViewController.goToEventScreen()
                    /*let storyboard = UIStoryboard(name: "Main", bundle: nil);
                    let vc = storyboard.instantiateViewControllerWithIdentifier("MySecondSecreen") as! UIViewController // MySecondSecreen the storyboard ID
                    self.presentViewController(vc, animated: true, completion: nil)*/
                }
                */
                var index = Int(self.routeIDs[self.currentStep])
                
                var place = self.scribe.map[index]["PlaceType"]!
                    
                if place == "END" {
                    self.moveFinished = false
                    self.eventReady = true
                    self.eventType = .end
                    self.currentStep = 0
                }
            }
            
            playerNode.run(SKAction.sequence([move, setFinished]))
        }
    }
    
    // translates position relitive to the top left of the original map image
    // so that the new position can fit with the new scale and coordinate directions
    func translatePositionFromRaw(x: Int, y: Int) -> CGPoint {
        var newX = CGFloat(x) * scaleFromMap
        var newY = CGFloat(y) * scaleFromMap
        
        newX = mapNode.position.x - mapNode.size.width/2 + newX
        newY = mapNode.position.y + mapNode.size.height/2 - newY
        
        return CGPoint(x: newX, y: newY)
    }
    
    func translatePositionFromRaw(pos: CGPoint) -> CGPoint {
        playerPos = pos
        
        var newX = pos.x * scaleFromMap
        var newY = pos.y * scaleFromMap
        
        newX = mapNode.position.x - mapNode.size.width/2 + newX
        newY = mapNode.position.y + mapNode.size.height/2 - newY
        
        return CGPoint(x: newX, y: newY)
    }
    
    func createRoute(_ steps: Int) throws -> Bool {
        var totalItems = scribe.map.count
        var IDs = [UInt]()
        var chosen = [CGPoint]()
        /*
        for i in scribe.map {
            items.append(CGPoint(x: CGFloat(Int(i["PositionX"]!)!), y: CGFloat(Int(i["PositionY"]!)!)))
        }*/
        
        for i in 0...steps-2 {
            IDs.append(UInt(1 + Int(arc4random())%(totalItems - 2)))
        }
        IDs.sort()
        
        var densityScale = totalItems - 1 / steps - 1
        
        var adjustmentsCount = 0
        var a: UInt = 0
        var b: UInt = 0
        
        var i = 0
        
        for j in IDs {
            
            b = j
            
            if adjustmentsCount > densityScale {
                b = a + 1
                adjustmentsCount = 0
            }
            else if b >= a + 3
            {
                b = a + 3
                adjustmentsCount += 1
            }
            else if b > a + 1 && b <= a + 3 && adjustmentsCount > 0 {
                b -= 1
            }
            else if b <= a {
                b = a + 1
                adjustmentsCount -= 1
            }
            
            IDs[i] = b
            
            a = b
            i += 1
        }
        
        IDs.reverse()
        
        i = 0
        a = UInt(totalItems - 1)
        b = 0
        adjustmentsCount = 0
        
        for j in IDs {
            
            b = j
            
            if adjustmentsCount > densityScale {
                b = a - 1
                adjustmentsCount = 0
            }
            else if b <= a - 3 // crashing here
            {
                b = a - 3
                adjustmentsCount += 1
            }
            else if b < a - 1 && b >= a - 3 && adjustmentsCount > 0 {
                b += 1
            }
            else if b >= a {
                b = a - 1
                adjustmentsCount -= 1
            }
            
            IDs[i] = b
            
            a = b
            i += 1
        }
        
        IDs.reverse()
        
        // adding the corresponding elements based on IDs to route
        // including start and end points to route
        route.append(CGPoint(x: CGFloat(Int(scribe.map[0]["PositionX"]!)!), y: CGFloat(Int(scribe.map[0]["PositionY"]!)!)))
        
        i = 0
        var j = 0
        var next = IDs[j]
        for m in scribe.map {
            if i == next {
                route.append(CGPoint(x: CGFloat(Int(m["PositionX"]!)!), y: CGFloat(Int(m["PositionY"]!)!)))
                j += 1
                if j != IDs.count {
                    next = IDs[j]
                }
            }
            i += 1
        }
        route.append(CGPoint(x: CGFloat(Int(scribe.map[scribe.map.endIndex - 1]["PositionX"]!)!), y: CGFloat(Int(scribe.map[scribe.map.endIndex - 1]["PositionY"]!)!)))
        
        IDs.insert(0, at: IDs.startIndex)
        IDs.append(UInt(scribe.map.count - 1))
        routeIDs = IDs
        // returns true if function doesn't crash
        return true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            var distance = CGFloat(t.location(in: self).x - t.previousLocation(in: self).x)
            cam.position.x -= distance
        }
    }
    
    override func didFinishUpdate() {
        if cam.position.x + screenWidth/2 > mapNode.size.width/2 {
            cam.position.x = mapNode.size.width/2 - screenWidth/2
        }
        else if cam.position.x - screenWidth/2 < -mapNode.size.width/2 {
            cam.position.x = -mapNode.size.width/2 + screenWidth/2
        }
    }
}
