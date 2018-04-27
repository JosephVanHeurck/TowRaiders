//
//  InputOutput.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 19/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import Foundation

// handles all reading and writing of data
class Scribe {
    // account data
    var playerCharacterList: [[String:String]]!
    var playerWeaponList: [[String:String]]!
    
    // session data
    var combatEnemyData: [[String:String]]!
    var playerPartyData: [[String:String]]!
    var route: [[String:String]]!
    
    // game data
    var abilities: [[String:String]]!
    var classBaseStats: [[String:String]]!
    var weaponBaseStats: [[String:String]]!
    
    // CREATE METHOD OF CREATING MEANINGFUL DATA STRUCTURE FOR ANIMATION ITEMS
    // animation data
    //var animationData:
    //var animationTemplateData:
    
    // temp data
    var map: [[String:String]]!
    
    func read(withName: String) {
        var fileElements = readFile(withName: withName)
        
        switch withName {
        case "PlayerCharacterList":
            playerCharacterList = fileElements
        case "PlayerWeaponList":
            playerWeaponList = fileElements
        case "PlayerPartyData":
            playerPartyData = fileElements
        case "CombatEnemyData":
           combatEnemyData = fileElements
        case "Abilities":
            abilities = fileElements
        case "classBaseStats":
            classBaseStats = fileElements
        case "weaponBaseStats":
            weaponBaseStats = fileElements
        case "Route":
            weaponBaseStats = fileElements
        default:
            if withName.hasPrefix("MapExplorationPlaces") {
                map = fileElements
            }
            break
        }
    }
    
    // reads file and stores file data into an array of dictionaries
    // so that elements in each rows of data can be called by their field name
    func readFile(withName: String) -> [[String:String]] {
        var fileElements = [[String:String]]()
        let filePath = Bundle.main.path(forResource: withName, ofType: "csv")
        var file : String!
        do {
            file = try String(contentsOfFile: filePath!, encoding: .utf8)
        }
        catch {
            
        }
        
        // Cleaning file
        file = file.replacingOccurrences(of: "\r", with: "\n")
        file = file.replacingOccurrences(of: "\n\n", with: "\n")
        if file.hasSuffix("\n"){
            file = String(file.prefix(upTo: file.index(file.endIndex, offsetBy:-1)))
        }
        
        var fileRows = file.components(separatedBy: "\n")
        var fieldNames = fileRows[0].components(separatedBy: ",")
        var i = 0
        for r in fileRows {
            if i != 0 {
                var fields = r.components(separatedBy: ",")
                var rowDictionary = [String:String]()
                var j = 0
                for f in fields {
                    rowDictionary[fieldNames[j]] = f
                    j = j + 1
                }
                fileElements.append(rowDictionary)
            }
            i = i + 1
        }
    return fileElements
    }
}
