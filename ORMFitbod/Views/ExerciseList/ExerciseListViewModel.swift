//
//  ExerciceListViewModel.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class ExerciseListViewModel: NSObject {
    
    private let exerciceService: ExerciseService
    private var exercicesObservable: SimpleObservable<PromiseObject<[Exercise]>>
    
    let title: SimpleObservable<String> = SimpleObservable(value: "Exercises")
    let isLoading: SimpleObservable<Bool> = SimpleObservable(value: false)
    let message: SimpleObservable<String?> = SimpleObservable(value: nil)
    let exercisesUpdate: SimpleObservable<Bool> = SimpleObservable(value: false)
    let selectedExercise: SimpleObservable<Exercise?> = SimpleObservable(value: nil)
    
    
    deinit {
        //Check deinit for memory leaks prevention
        Utils.printDebug(sender: self, message: "deinit")
    }
    
    init(service: ExerciseService = ExerciseService.shared) {
        self.exerciceService = service
        self.exercicesObservable = service.fetchExercises()
        super.init()
        
        bindExercisesPromise()
    }
    
    func bindExercisesPromise() {
        
        exercicesObservable.observe { [weak self] (promise) in
            self?.isLoading.accept(promise.state == .loading)
            self?.message.accept(promise.message)
            self?.exercisesUpdate.accept(true)
        }
        
    }

}

///Extension to define table view related functionality
extension ExerciseListViewModel {
    
    func numberOfRows() -> Int {
        return exercicesObservable.current().object?.count ?? 0
    }
    
    func cellType(at indexPath: IndexPath) -> ExerciseListCellType? {
        guard let exercices = exercicesObservable.current().object else {
            return nil
        }
        return .execiseCell(exercise: exercices[indexPath.row])
    }
    
    func handleExerciseSelection(at indexPath: IndexPath) {
        guard let exercice = exercicesObservable.current().object?[safe: indexPath.row] else {
            return
        }
        
        self.selectedExercise.accept(exercice)
    }
}
