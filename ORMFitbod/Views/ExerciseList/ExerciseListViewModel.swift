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
            print("***")
            Utils.printDebug(sender: self, message: "State: \(promise.state)")
            Utils.printDebug(sender: self, message: "Object: \(promise.object)")
            Utils.printDebug(sender: self, message: "Message: \(promise.message)")
            print("***")
            
            self?.isLoading.accept(promise.state == .loading)
            self?.message.accept(promise.message)
            self?.exercisesUpdate.accept(true)
        }
        
    }

}
