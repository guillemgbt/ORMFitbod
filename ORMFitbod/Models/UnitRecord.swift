//
//  UnitRecord.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class UnitRecord: NSObject, OneRepMaxProvider {
    
    let sets: Int
    let reps: Int
    let weight: Int
    
    init?(sets: Int, reps: Int, weight: Int) {
        
        guard sets > 0, reps > 0, weight > 0 else {
            return nil
        }
        
        self.sets = sets
        self.reps = reps
        self.weight = weight
        super.init()
    }
    
    func get1RM() -> Float {
        /*
         Since we know that sets and reps are inmutable and
         checked that are grater than 0, we parse the 1RM that way
         */
        return (try? WorkoutCalculator.compute1RM(weight: weight, reps: reps)) ?? 0.0
    }

}
