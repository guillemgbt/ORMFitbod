//
//  ExerciceService.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class ExerciceService: NSObject {
    
    static let shared: ExerciceService = ExerciceService()
    
    private let workoutParser: WorkoutParser
    
    init(parser: WorkoutParser = WorkoutParser()) {
        self.workoutParser = parser
    }
    
    func fetchExercices() -> SimpleObservable<PromiseObject<[Exercice]>> {
        
        let loadingPromise: PromiseObject<[Exercice]> = PromiseObject(state: .loading)
        let exercices: SimpleObservable<PromiseObject<[Exercice]>> = SimpleObservable(value: loadingPromise)
        
        DispatchQueue.global().async {
            let promiseExercices = self.workoutParser.parse()
            exercices.accept(promiseExercices)
        }
                
        return exercices
    }

}
