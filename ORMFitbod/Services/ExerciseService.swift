//
//  ExerciceService.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class ExerciseService: NSObject {
    
    static let shared: ExerciseService = ExerciseService()
    
    private let workoutParser: WorkoutParser
    
    init(parser: WorkoutParser = WorkoutParser()) {
        self.workoutParser = parser
    }
    
    func fetchExercises() -> SimpleObservable<PromiseObject<[Exercise]>> {
        
        let loadingPromise: PromiseObject<[Exercise]> = PromiseObject(state: .loading)
        let exercices: SimpleObservable<PromiseObject<[Exercise]>> = SimpleObservable(value: loadingPromise)
        
        DispatchQueue.global().async {
            let promiseExercices = self.workoutParser.parse()
            exercices.accept(promiseExercices)
        }
        
        return exercices
    }

}
