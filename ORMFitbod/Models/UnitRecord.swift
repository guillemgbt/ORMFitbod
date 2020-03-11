//
//  UnitRecord.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class UnitRecord: NSObject {
    
    let sets: Int
    let reps: Int
    let weight: Int
    
    init(sets: Int, reps: Int, weight: Int) {
        self.sets = sets
        self.reps = reps
        self.weight = weight
        super.init()
    }
    
    func get1RM() -> Int {
        return 0
    }

}
