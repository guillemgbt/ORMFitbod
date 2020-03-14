//
//  ExerciseStatsViewModel.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class ExerciseStatsViewModel: NSObject {
    
    private let exercise: Exercise
    
    let name = SimpleObservable<String>(value: "")
    let description1RM = SimpleObservable<String>(value: "")
    let value1RM = SimpleObservable<String>(value: "")
    
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init()
        
        setObservables()
    }
    
    deinit {
       //Check deinit for memory leaks prevention
       Utils.printDebug(sender: self, message: "deinit")
    }
    
    private func setObservables() {
        self.name.accept(self.exercise.name)
        self.description1RM.accept("One Rep Max • lbs")
        self.value1RM.accept("\(Int(self.exercise.get1RM()))")
    }

}
