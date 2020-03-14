//
//  ExerciseStatsViewModel.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class ExerciseStatsViewModel: NSObject {
    
    let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init()
    }

}
