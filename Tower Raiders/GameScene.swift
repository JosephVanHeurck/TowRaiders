//
//  GameScene.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 24/3/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import SpriteKit
import GameplayKit

enum ActionType {
    case none
    case attack
    case ability
    case defend
    case swap
}

enum Target {
    case user
    case singleEnemy
    case allEnimies
    case singleAlly
    case allAllies
}

enum aniStyle {
    case none
    case damagedFadeCycle
    case damageNumber
    case healingNumber
}

struct animationItem {
    var startTime: Double
    var endTime: Double
    var texture: String = "idle"
    var style: aniStyle = .none
    var animationTarget: Target = .user
    var isDone = false
    init(_ start: Double, _ end: Double) {
        startTime = start
        endTime = end
    }
    init(_ start: Double, _ end: Double, texture: String) {
        startTime = start
        endTime = end
        self.texture = texture
    }
    init(_ start: Double, _ end: Double, texture: String, target: Target) {
        startTime = start
        endTime = end
        self.texture = texture
        animationTarget = target
    }
    init(_ start: Double, _ end: Double, texture: String, target: Target, style: aniStyle) {
        startTime = start
        endTime = end
        self.texture = texture
        animationTarget = target
        self.style = style
    }
}

struct abilityInfo {
    var ID : UInt
    var abilityName : String
    var target : Target = .singleEnemy
    var healing : Bool = false
    var cost : UInt
    var mod : Float
    var animation = [animationItem]()
    init(id: UInt, name: String, target: String, healing : Bool, cost: UInt, mod: Float, animation: [animationItem]) {
        self.ID = id
        self.abilityName = name
        
        // when called string must be converted to bool
        self.healing = healing
        self.cost = cost
        self.mod = mod
        
        self.animation = animation
        
        switch target {
        case "user":
            self.target = .user
        case "single enemy":
            self.target = .singleEnemy
        case "all enemies":
            self.target = .allEnimies
        case "single ally":
            self.target = .singleAlly
        case "all allies":
            self.target = .allAllies
        default:
            break
        }
    }
}

var abilityNames: [Int: String] = [0 : "Heavy Swipe", 1 : "Stab Vitals", 2 : "Air Slash", 3 : "Light healing", 4 : "Party Healing"]

class Character {
    var ID : UInt = 0
    var side : Bool = true
    var textureName : String
    var power : UInt = 0
    var def : UInt = 0
    var maxHP : UInt = 0
    var HP : Int = 0
    var maxMP: UInt = 0
    var MP : Int = 0
    var abilities = [abilityInfo]()
    init(_ id: UInt, _ side: Bool, _ texName: String, _ power: UInt, _ def : UInt, _ maxHP: UInt, _ currentHP: UInt, _ maxMP: UInt, _ currentMP : UInt, _ abilities: [abilityInfo]) {
        self.ID = id
        self.side = side
        self.textureName = texName
        self.power = power
        self.def = def
        self.maxHP = maxHP
        self.HP = Int(currentHP)
        self.maxMP = maxMP
        self.MP = Int(currentMP)
    }
}

// dirivitive of SKScene that allows for inputs from parent object a.k.a. the View Controller
class CombatScene : SKScene {
    var feedbackLblNode0 = SKLabelNode()
    var feedbackLblNode1 = SKLabelNode()
    var feedbackLblNode2 = SKLabelNode()
    var feedbackLblNode3 = SKLabelNode()
    var feedbackLblNode4 = SKLabelNode()
    var feedbackLblNode5 = SKLabelNode()
    
    var charNode0 = SKSpriteNode()
    var charNode1 = SKSpriteNode()
    var charNode2 = SKSpriteNode()
    var charNode3 = SKSpriteNode()
    var charNode4 = SKSpriteNode()
    var charNode5 = SKSpriteNode()
    
    
    var characterList : [Character] = [Character]()
    var currentCharacter : Character!
    // action input variables
    var actType: ActionType = .none
    var actName : String = "none"
    var actTarget : Int = -1
    
    //var aniIdle = animationItem(0, 0.5)
    //var aniAttack = animationItem(0.5, 1.5, texture: "attack")
    //var aniAttackBrace = animationItem(0.3, 0.5, texture: "brace", target: .singleEnemy)
    //var aniAttackRecieved = animationItem(0.5, 1.0, texture: "brace", target: .singleEnemy, style: .whiteFadeIn)
    //var aniDamageNumber = animationItem(0.5, 1.5, texture: "damage", target: .singleEnemy, style: .damageNumber)
    
    var UserAttackAniTemplate: [animationItem] = [animationItem(0, 0.5),animationItem(0.5, 1.5, texture: "attack")]
    var TargetAttackAniTemplate: [animationItem] = [animationItem(0, 0.3, texture: "idle", target: .singleEnemy), animationItem(0.3, 0.5, texture: "brace", target: .singleEnemy), animationItem(0.5, 1.0, texture: "brace", target: .singleEnemy, style: .damagedFadeCycle)]
    
    var userAnimation = [animationItem]()
    var targetAnimation = [animationItem]()
    
    // animationList Vector
    
    // IDs that can be targeted (are active)
    var targetables = [UInt]()
    
    
    // stores default positions of feedback labels
    var defaultFbackLblPos = [CGPoint]()
    
    var isAnimating : Bool = false
    
    // recieve button input from parent object, a.k.a. View Controller
    func setAction(type: ActionType, name: String, target: Int) {
        actType = type
        actName = name
        actTarget = target
    }
    
    func getCharacter(id:Int) -> Character {
        // CHANGE RETURNING OBJECT TO POINTER OF OBJECT
        var char : Character!
        for c in characterList {
            if c.ID == id {
                char = c
            }
        }
        return char
    }
    
    func setCharacter(_ char: Character) {
        for c in characterList {
            var i = 0
            if c.ID == char.ID {
                characterList[i] = char
                i += 1
            }
        }
    }
    
    func doAction() {
        switch actType {
        case .attack:
            let recipient = getCharacter(id: actTarget)
            let damage = Int(currentCharacter.power - (recipient.def / 2))
            recipient.HP -= damage
            setCharacter(recipient)
            // SETUP ANIMATION LIST
            var tempAni = TargetAttackAniTemplate
            tempAni.append(animationItem(0.5, 1.5, texture: String(damage), target: .singleEnemy, style: .damageNumber))
            
            userAnimation = UserAttackAniTemplate
            targetAnimation = tempAni
        case .ability:
            break
        case .defend:
            break
        case .swap:
            break
        default:
            break
        }
        isAnimating = true
    }
    
    func animate() {
        // test animation //
        /*
         var targetAct = [SKAction]()
         var targetNumbersAct = [SKAction]()
         var targetNumbersAct2 = [SKAction]()
         
         let interval: Double = 0.1
         
         targetAct.append(SKAction.wait(forDuration: 0.5))
         targetAct.append(SKAction.setTexture(SKTexture(imageNamed: "braceEvilKnight")))
         targetAct.append(SKAction.wait(forDuration: 0.2))
         targetAct.append(SKAction.fadeOut(withDuration: interval))
         targetAct.append(SKAction.fadeIn(withDuration: interval))
         targetAct.append(SKAction.fadeOut(withDuration: interval))
         targetAct.append(SKAction.fadeIn(withDuration: interval))
         targetAct.append(SKAction.setTexture(SKTexture(imageNamed: "idleEvilKnight")))
         
         targetNumbersAct.append(SKAction.wait(forDuration: 0.7))
         targetNumbersAct2.append(SKAction.wait(forDuration: 0.7))
         targetNumbersAct.append(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
         targetNumbersAct.append(SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1))
         targetNumbersAct2.append(SKAction.fadeIn(withDuration: 0))
         targetNumbersAct2.append(SKAction.fadeOut(withDuration: 1))
         
         charNode3.run(SKAction.sequence(targetAct))
         feedbackLblNode3.run(SKAction.sequence(targetNumbersAct))
         feedbackLblNode3.run(SKAction.sequence(targetNumbersAct2))*/
        ////////////////////
        
        
        // action vectors used for animation
        var actUserAnimation = [SKAction]()
        
        // 2 action vectors are used for simultaneous actions
        var actUserNumbers = [SKAction]()
        var actUserNumbers2 = [SKAction]()
        
        var actTargetAnimation = Array(repeating: [SKAction](), count: 6)
        
        var actTargetNumbers = Array(repeating: [SKAction](), count: 6)
        var actTargetNumbers2 = Array(repeating: [SKAction](), count: 6)
        
        // action vector for ending animation after waiting action
        // acts as end timer
        var actEnd = [SKAction]()
        
        var aniEndTime: Double
        var tempTime: Double
        var aniEndTarget: Target
        
        // getting the end time for whole animation
        aniEndTime = userAnimation[userAnimation.count - 1].endTime
        tempTime = targetAnimation[targetAnimation.count - 1].endTime
        
        if aniEndTime < tempTime {
            aniEndTime = tempTime
        }
        
        actEnd.append(SKAction.wait(forDuration: aniEndTime))
        actEnd.append(SKAction.run({self.endAnimation()}))
        
        for a in userAnimation {
            var interval: Double
            interval = a.endTime - a.startTime
            var texture: SKTexture
            
            // add wait action to list if no immediate animation item
            if actUserAnimation.isEmpty && a.startTime > 0 {
                actUserAnimation.append(SKAction.wait(forDuration: a.startTime))
            }
            if a.style != .damageNumber && a.style != .healingNumber {
                // adding texture setting action and waiting action to animation list
                let texName = a.texture + currentCharacter.textureName
                texture = SKTexture(imageNamed: texName)
                actUserAnimation.append(SKAction.setTexture(texture))
                switch a.style {
                case .damagedFadeCycle:
                    // fade cycle emphasises recieving damage
                    actUserAnimation.append(SKAction.fadeOut(withDuration: interval/4))
                    actUserAnimation.append(SKAction.fadeIn(withDuration: interval/4))
                    actUserAnimation.append(SKAction.fadeOut(withDuration: interval/4))
                    actUserAnimation.append(SKAction.fadeIn(withDuration: interval/4))
                default:
                    actUserAnimation.append(SKAction.wait(forDuration: interval))
                }
                
            }
            else {
                if actUserNumbers.isEmpty && a.startTime > 0 {
                    actUserNumbers.append(SKAction.wait(forDuration: a.startTime))
                    actUserNumbers2.append(SKAction.wait(forDuration: a.startTime))
                }
                actUserNumbers.append(SKAction.run({self.setNodeText(a.texture, UInt(self.currentCharacter.ID))}))
                let originalPosition: CGPoint = defaultFbackLblPos[Int(currentCharacter.ID)]
                actUserNumbers.append(SKAction.move(to: originalPosition, duration: 0))
                //actUserNumbers.append(SKAction.colorize(withColorBlendFactor: 1, duration: interval))
                
                if a.style == .damageNumber {
                    actUserNumbers.append(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
                }
                else {
                    actUserNumbers.append(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0))
                }
                
                actUserNumbers2.append(SKAction.fadeIn(withDuration: 0))
                actUserNumbers.append(SKAction.move(by: CGVector(dx: 0, dy: 100), duration: interval))
                actUserNumbers2.append(SKAction.fadeOut(withDuration: interval))
                
            }
        }
        if !userAnimation.isEmpty {
            let texture = SKTexture(imageNamed: "idle" + currentCharacter.textureName)
            actUserAnimation.append(SKAction.setTexture(texture))
        }
        
        var targets = [Int]()
        if targetAnimation[0].animationTarget == .singleEnemy || targetAnimation[0].animationTarget == .singleAlly {
            targets.append(actTarget)
        }
        else if targetAnimation[0].animationTarget == .allAllies {
            targets.append(contentsOf:[0,1,2])
        }
        else {
            targets.append(contentsOf:[3,4,5])
        }
        
        for t in targets {
            // COPY CODE IN userAnimation SCOPE
            for a in targetAnimation {
                var interval: Double
                interval = a.endTime - a.startTime
                var texture: SKTexture
                
                var targetChar: Character!
                
                // no longer in use
                for i in characterList {
                    if i.ID == t {
                        targetChar = i
                    }
                }
                
                // add wait action to list if no immediate animation item
                if actTargetAnimation[t].isEmpty && a.startTime > 0 {
                    actTargetAnimation[t].append(SKAction.wait(forDuration: a.startTime))
                    // this block isn't being used??
                }
                if a.style != .damageNumber && a.style != .healingNumber {
                    // adding texture setting action and waiting action to animation list
                    let texName = a.texture + targetChar.textureName
                    texture = SKTexture(imageNamed: texName)
                    actTargetAnimation[t].append(SKAction.setTexture(texture))
                    switch a.style {
                    case .damagedFadeCycle:
                        // fade cycle emphasises recieving damage
                        actTargetAnimation[t].append(SKAction.fadeOut(withDuration: interval/4))
                        actTargetAnimation[t].append(SKAction.fadeIn(withDuration: interval/4))
                        actTargetAnimation[t].append(SKAction.fadeOut(withDuration: interval/4))
                        actTargetAnimation[t].append(SKAction.fadeIn(withDuration: interval/4))
                    default:
                        actTargetAnimation[t].append(SKAction.wait(forDuration: interval))
                    }
                }
                else {
                    if actTargetNumbers[t].isEmpty && a.startTime > 0 {
                        actTargetNumbers[t].append(SKAction.wait(forDuration: a.startTime))
                        actTargetNumbers2[t].append(SKAction.wait(forDuration: a.startTime))
                        
                    }
                    actTargetNumbers[t].append(SKAction.run({self.setNodeText(a.texture, UInt(t))}))
                    let originalPosition: CGPoint = defaultFbackLblPos[t]
                    actTargetNumbers[t].append(SKAction.move(to: originalPosition, duration: 0))
                    if a.style == .damageNumber {
                        actTargetNumbers[t].append(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
                    }
                    else {
                        actTargetNumbers[t].append(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0))
                    }
                    
                    actTargetNumbers2[t].append(SKAction.fadeIn(withDuration: 0))
                    actTargetNumbers[t].append(SKAction.move(by: CGVector(dx: 0, dy: 100), duration: interval))
                    actTargetNumbers2[t].append(SKAction.fadeOut(withDuration: interval))
                }
            }
            
            if !actTargetAnimation[t].isEmpty {
                var targetChar: Character!
                for i in characterList {
                    if i.ID == t {
                        targetChar = i
                    }
                }
                let texture = SKTexture(imageNamed: "idle" + targetChar.textureName)
                actTargetAnimation[t].append(SKAction.setTexture(texture))
            }
        }
        
        // running animation action sequence for user node and user feedback node
        switch currentCharacter.ID {
        case 0:
            charNode0.run(SKAction.sequence(actUserAnimation))
            feedbackLblNode0.run(SKAction.sequence(actUserNumbers))
            feedbackLblNode0.run(SKAction.sequence(actUserNumbers2))
        case 1:
            charNode1.run(SKAction.sequence(actUserAnimation))
            feedbackLblNode1.run(SKAction.sequence(actUserNumbers))
            feedbackLblNode1.run(SKAction.sequence(actUserNumbers2))
        case 2:
            charNode2.run(SKAction.sequence(actUserAnimation))
            feedbackLblNode2.run(SKAction.sequence(actUserNumbers))
            feedbackLblNode2.run(SKAction.sequence(actUserNumbers2))
        case 3:
            charNode3.run(SKAction.sequence(actUserAnimation))
            feedbackLblNode3.run(SKAction.sequence(actUserNumbers))
            feedbackLblNode3.run(SKAction.sequence(actUserNumbers2))
        case 4:
            charNode4.run(SKAction.sequence(actUserAnimation))
            feedbackLblNode4.run(SKAction.sequence(actUserNumbers))
            feedbackLblNode4.run(SKAction.sequence(actUserNumbers2))
        case 5:
            charNode5.run(SKAction.sequence(actUserAnimation))
            feedbackLblNode5.run(SKAction.sequence(actUserNumbers))
            feedbackLblNode5.run(SKAction.sequence(actUserNumbers2))
        default:
            break
        }
        
        // running action sequences for target nodes and target feedback nodes
        for t in targets {
            switch t {
            case 0:
                charNode0.run(SKAction.sequence(actTargetAnimation[t]))
                feedbackLblNode0.run(SKAction.sequence(actTargetNumbers[t]))
                feedbackLblNode0.run(SKAction.sequence(actTargetNumbers2[t]))
            case 1:
                charNode1.run(SKAction.sequence(actTargetAnimation[t]))
                feedbackLblNode1.run(SKAction.sequence(actTargetNumbers[t]))
                feedbackLblNode1.run(SKAction.sequence(actTargetNumbers2[t]))
            case 2:
                charNode2.run(SKAction.sequence(actTargetAnimation[t]))
                feedbackLblNode2.run(SKAction.sequence(actTargetNumbers[t]))
                feedbackLblNode2.run(SKAction.sequence(actTargetNumbers2[t]))
            case 3:
                charNode3.run(SKAction.sequence(actTargetAnimation[t]))
                feedbackLblNode3.run(SKAction.sequence(actTargetNumbers[t]))
                feedbackLblNode3.run(SKAction.sequence(actTargetNumbers2[t]))
            case 4:
                charNode4.run(SKAction.sequence(actTargetAnimation[t]))
                feedbackLblNode4.run(SKAction.sequence(actTargetNumbers[t]))
                feedbackLblNode4.run(SKAction.sequence(actTargetNumbers2[t]))
            case 5:
                charNode5.run(SKAction.sequence(actTargetAnimation[t]))
                feedbackLblNode5.run(SKAction.sequence(actTargetNumbers[t]))
                feedbackLblNode5.run(SKAction.sequence(actTargetNumbers2[t]))
            default:
                break
            }
        }
        
        // running end timer action sequence
        charNode0.run(SKAction.sequence(actEnd))
 
    }
    
    func setNodeText(_ text: String, _ node: UInt) {
        switch node {
        case 0:
            feedbackLblNode0.text = text
        case 1:
            feedbackLblNode1.text = text
        case 2:
            feedbackLblNode2.text = text
        case 3:
            feedbackLblNode3.text = text
        case 4:
            feedbackLblNode4.text = text
        case 5:
            feedbackLblNode5.text = text
        default:
            break
        }
    }
    
    // is executed when SKAction sequence is finished
    func endAnimation() {
        isAnimating = false
        currentCharacter = getNextCharacter()
        actType = .none
    }
    
    func getNextCharacter() -> Character {
        let temp = characterList[0]
        characterList.append(temp)
        characterList.remove(at: 0)
        return characterList[0]
    }
}

class GameScene: CombatScene {
    var actionLblNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        actionLblNode = self.childNode(withName: "ActionLbl") as! SKLabelNode
        
        feedbackLblNode0 = self.childNode(withName: "FeedbackLbl0") as! SKLabelNode
        feedbackLblNode1 = self.childNode(withName: "FeedbackLbl1") as! SKLabelNode
        feedbackLblNode2 = self.childNode(withName: "FeedbackLbl2") as! SKLabelNode
        feedbackLblNode3 = self.childNode(withName: "FeedbackLbl3") as! SKLabelNode
        feedbackLblNode4 = self.childNode(withName: "FeedbackLbl4") as! SKLabelNode
        feedbackLblNode5 = self.childNode(withName: "FeedbackLbl5") as! SKLabelNode
        
        defaultFbackLblPos.append(feedbackLblNode0.position)
        defaultFbackLblPos.append(feedbackLblNode1.position)
        defaultFbackLblPos.append(feedbackLblNode2.position)
        defaultFbackLblPos.append(feedbackLblNode3.position)
        defaultFbackLblPos.append(feedbackLblNode4.position)
        defaultFbackLblPos.append(feedbackLblNode5.position)
        
        charNode0 = self.childNode(withName: "Char0") as! SKSpriteNode
        charNode1 = self.childNode(withName: "Char1") as! SKSpriteNode
        charNode2 = self.childNode(withName: "Char2") as! SKSpriteNode
        charNode3 = self.childNode(withName: "Char3") as! SKSpriteNode
        charNode4 = self.childNode(withName: "Char4") as! SKSpriteNode
        charNode5 = self.childNode(withName: "Char5") as! SKSpriteNode
        
        // testing Scribe readFile function
        var scribe = Scribe()
        var myWeaponList = scribe.readFile(withName: "PlayerWeaponList")
        
        var dummyAbilities = [abilityInfo]()
        /*
        var dummyAbility = abilityInfo(id: 0, name: "heavy Swipe", target: "single enemy", healing: false, cost: 3, mod: 1.5)
        dummyAbilities.append(dummyAbility)
        dummyAbility = abilityInfo(id: 1, name: "Stab Vitals", target: "single enemy", healing: false, cost: 8, mod: 2.2)
        dummyAbilities.append(dummyAbility)
        dummyAbility = abilityInfo(id: 2, name: "Air Slash", target: "all enemies", healing: false, cost: 6, mod: 0.8)
        dummyAbilities.append(dummyAbility)
        dummyAbility = abilityInfo(id: 3, name: "Light Healing", target: "single ally", healing: true, cost: 4, mod: 2.0)
        dummyAbilities.append(dummyAbility)
        dummyAbility = abilityInfo(id: 4, name: "Group Healing", target: "all allies", healing: true, cost: 9, mod: 1.0)
        dummyAbilities.append(dummyAbility)*/
        
        var dummyAlly = Character(0, true, "Knight", 10, 10, 100, 100, 20, 20, dummyAbilities)
        characterList.append(dummyAlly)
        dummyAlly = Character(1, true, "Knight", 10, 10, 100, 100, 20, 20, dummyAbilities)
        characterList.append(dummyAlly)
        dummyAlly = Character(2, true, "Knight", 10, 10, 100, 100, 20, 20, dummyAbilities)
        characterList.append(dummyAlly)
        var dummyEnemy = Character(3, false, "EvilKnight", 10, 10, 100, 100, 20, 20, dummyAbilities)
        characterList.append(dummyEnemy)
        dummyEnemy = Character(4, false, "EvilKnight",  10, 10, 100, 100, 20, 20, dummyAbilities)
        characterList.append(dummyEnemy)
        dummyEnemy = Character(5, false, "EvilKnight",  10, 10, 100, 100, 20, 20, dummyAbilities)
        characterList.append(dummyEnemy)
        
        currentCharacter = characterList[0]
        
        for c in characterList {
            targetables.append(c.ID)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // label feedback for input
        switch actType {
        case .none:
            actionLblNode.text = "none"
        case .attack:
            actionLblNode.text = "attack"
        case .ability:
            actionLblNode.text = "ability"
        case .defend:
            actionLblNode.text = "defend"
        case .swap:
            actionLblNode.text = "swap"
        }
        
        // game logic pauses whilst animating
        if isAnimating == false {
            if currentCharacter.side == true {
                // On player character turn, update loop waits for player input
                if actType != .none {
                    //  does action based on action type
                    doAction()
                    //  run SKAction sequences in order to animate nodes
                    animate()
                }
            }
            else {
                //CALCULATE ENEMY ACTION
            }
        }
    }
}
