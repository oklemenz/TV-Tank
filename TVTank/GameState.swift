//
//  GameState.swift
//  TVTank
//
//  Created by Oliver Klemenz on 10.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation

class GameState {
    
    let maxLevelPack = 1
    let maxLevel = 20
    
    var levelPack = 1
    var level = 1
    
    var state : [[[String:Int]]] = []
    
    static let instance = GameState()
    
    init() {
        for i in 0..<maxLevelPack {
            state.append([])
            for _ in 0..<maxLevel {
                state[i].append(["box" : 0, "spot" : 0, "play" : 0])
            }
        }
        load()
    }
    
    func load() {
        let userDefault = UserDefaults.standard
        levelPack = max(userDefault.integer(forKey: "levelPack"), 1)
        level = max(userDefault.integer(forKey: "level"), 1)
        if let codedState = userDefault.object(forKey: "state") as? Data {
            let loadedState = NSKeyedUnarchiver.unarchiveObject(with: codedState) as! [[[String:Int]]]
            for i in 0..<maxLevelPack {
                for j in 0..<maxLevel {
                    if i < loadedState.count && j < loadedState[i].count {
                        state[i][j] = loadedState[i][j]
                    }
                }
            }
        }
    }
    
    func store() {
        let userDefault = UserDefaults.standard
        userDefault.set(levelPack, forKey:"levelPack")
        userDefault.set(level, forKey:"level")
        userDefault.set(NSKeyedArchiver.archivedData(withRootObject: state), forKey:"state")
        userDefault.synchronize()
    }
    
    func getState(_ level : Int) -> [String:Int]? {
        if levelPack <= state.count && level <= state[levelPack-1].count {
            return state[levelPack-1][level-1]
        }
        return nil
    }
    
    func setState(_ stateValue : [String:Int]) {
        if levelPack <= state.count && level <= state[levelPack-1].count {
            let levelState = getState(level)
            if var levelState = levelState {
                if stateValue["spot"]! == 3 && levelState["spot"]! != 3 {
                    levelState["box"] = stateValue["box"]!
                    levelState["spot"] = stateValue["spot"]!
                } else {
                    levelState["box"] = max(levelState["box"]!, stateValue["box"]!)
                    levelState["spot"] = max(levelState["spot"]!, stateValue["spot"]!)
                }
                levelState["play"] = max(levelState["play"]!, stateValue["play"]!)
                state[levelPack-1][level-1] = levelState
            } else {
                state[levelPack-1][level-1] = stateValue
            }
        }
    }
    
    func levelCompleted(_ box : Int) {
        setState([ "box" : box, "spot" : 3, "play" : 1])
        if level < maxLevel {
            level += 1
        }
        store()
    }
    
    func levelFailed(_ box : Int, spot : Int) {
        setState([ "box" : box, "spot" : spot, "play" : 1])
        store()
    }
}

class LevelState : NSObject, NSCoding {
    
    var spot : Int = 0
    var box : Int = 0
    
    override init() {
    }
    
    convenience init(spot: Int, box: Int) {
        self.init()
        self.spot = spot
        self.box = box
    }
    
    required init(coder aDecoder: NSCoder) {
        if let spot = aDecoder.decodeObject(forKey: "spot") as? Int {
            self.spot = spot
        }
        if let box = aDecoder.decodeObject(forKey: "box") as? Int {
            self.box = box
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.spot, forKey: "spot")
        aCoder.encode(self.box, forKey: "box")
    }
}
