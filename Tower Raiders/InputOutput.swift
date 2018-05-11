//
//  InputOutput.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 19/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import Foundation

struct dataAndFields {
    var data: [[String:String]]!
    var fields: [String]!
}

// handles all reading and writing of data
class Scribe {
    // account data
    var playerCharacterList = [[String:String]]()
    var playerCharacterListFields : [String]!
    var playerWeaponList = [[String:String]]()
    var playerWeaponListFields: [String]!
    
    // session data
    var combatEnemyData = [[String:String]]()
    var combatEnemyDataFields: [String]!
    var playerPartyData = [[String:String]]()
    var playerPartyDataFields: [String]!
    var route = [[String:String]]()
    var routeFields: [String]!
    
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
    
    func read(_ withName: String) {
        var result = readFile(withName)
        var data = result.data
        var fields = result.fields
        
        switch withName {
        case "PlayerCharacterList":
            playerCharacterList = data!
            playerCharacterListFields = fields
        case "PlayerWeaponList":
            playerWeaponList = data!
            playerWeaponListFields = fields
        case "PlayerPartyData":
            playerPartyData = data!
            playerPartyDataFields = fields
        case "CombatEnemyData":
            combatEnemyData = data!
           combatEnemyDataFields = fields
        case "Abilities":
            abilities = data
        case "classBaseStats":
            classBaseStats = data
        case "weaponBaseStats":
            weaponBaseStats = data
        case "Route":
            route = data!
            routeFields = fields
        default:
            if withName.hasPrefix("MapExplorationPlaces") {
                map = data
            }
            break
        }
    }
    
    func write(_ withName: String) {
        var data: [[String:String]]!
        var fields: [String]!
        var type: String!
        
        switch withName {
        case "PlayerCharacterList":
            data = playerCharacterList
            fields = playerCharacterListFields
            type = "Account Data"
        case "PlayerWeaponList":
            data = playerWeaponList
            fields = playerWeaponListFields
            type = "Account Data"
        case "PlayerPartyData":
            data = playerPartyData
            fields = playerPartyDataFields
            type = "Session Data"
        case "CombatEnemyData":
            data = combatEnemyData
            fields = combatEnemyDataFields
            type = "Session Data"
        case "Route":
            data = route
            fields = routeFields
            type = "Session Data"
        default:
            break
        }
        
        writeFile(withName,type,data,fields)
    }
    
    // reads file and stores file data into an array of dictionaries
    // so that elements in each rows of data can be called by their field name
    func readFile(_ withName: String) -> dataAndFields {
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
        
    var result = dataAndFields()
    result.data = fileElements
    result.fields = fieldNames
        
    return result
    }
    
    func writeFile(_ withName: String, _ type: String, _ data: [[String: String]], _ fields: [String]) -> Void {
        var text = String()
        
        var i = 0
        for f in fields {
            text.append(f)
            if i != fields.count - 1 {
                text.append(",")
            }
            else {
                 text.append("\n")
            }
            i+=1
        }
        
        for d in data {
            i = 0
            for f in fields {
                text.append(d[f]!)
                if i != fields.count - 1 {
                    text.append(",")
                }
                i+=1
            }
            text.append("\n")
        }
        
        var type = ""
        var filePath = "Data/\(type)/\(withName).csv"
        text.write(to: &filePath)
        
    }
}
