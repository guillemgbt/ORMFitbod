//
//  WorkoutCalculator.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

enum WorkoutCalculatorError: Error {
    case invalidInputValues
}

class WorkoutCalculator: NSObject {
    
    static func compute1RM(weight: Int, reps: Int) throws -> Float {
        
        guard weight > 0, reps > 0 else {
            throw WorkoutCalculatorError.invalidInputValues
        }
        
        let divisor = max(0.00001, (37.0 - Float(reps))) //To avoid 0 division
                        
        return Float(weight)*36.0 / divisor
    }
}
