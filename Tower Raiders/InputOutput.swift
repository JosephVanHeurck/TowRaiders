//
//  InputOutput.swift
//  Tower Raiders
//
//  Created by Joseph Van Heurck on 19/4/18.
//  Copyright © 2018 Joseph Van Heurck. All rights reserved.
//

import Foundation
struct sessionCharStats {
    var lvl: UInt = 0
    var maxHP: UInt = 0
    var maxMP: UInt = 0
    var HP: Int = 0
    var MP: Int = 0
    var power: UInt = 0
    var defense: UInt = 0
    var magic: UInt = 0
    var resistance: UInt = 0
    var exp: UInt = 0
}

// data structure for characters
struct sessionCharacterData {
    let ID: UInt!
    var name: String = ""
    var charClass: String = ""
    var pallete: UInt = 0
    var stats: sessionCharStats = sessionCharStats()
    
    // IDs used for gathering data from equipment data tables
    // default value -1 represents none
    var weaponID: Int = -1
    var armourID: Int = -1
    var accessaryID1: Int = -1
    var accessaryID2: Int = -1
    
    init(id: UInt, lvl: UInt, charClass: String) {
        ID = id
        stats.lvl = lvl
        self.charClass = charClass
    }
}

// handles all reading and writing of data
class Scribe {
    
    // reads file and stores file data into an array of dictionaries
    // so that elements in each rows of data can be called by their field name
    func readFile(withName: String) -> [[String:String]] {
        var fileValues = [[String:String]]()
        let file = String(Bundle.main.path(forResource: withName, ofType: "cvs")!)
        var fileRows = file.components(separatedBy: "\n")
        var fieldNames = fileRows[0].components(separatedBy: ",")
        for r in fileRows {
            if r.count != 0 {
                var fields = r.components(separatedBy: ",")
                var rowDictionary = [String:String]()
                for f in fields {
                    rowDictionary[fieldNames[f.count]] = f
                }
                fileValues.append(rowDictionary)
            }
        }
    return fileValues
    }
}
