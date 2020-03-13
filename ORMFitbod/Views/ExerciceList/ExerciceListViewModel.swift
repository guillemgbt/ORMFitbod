//
//  ExerciceListViewModel.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class ExerciceListViewModel: NSObject {
    
    private let exerciceService: ExerciceService
    private var exercicesObservable: SimpleObservable<PromiseObject<[Exercice]>>
    
    init(service: ExerciceService = ExerciceService.shared) {
        self.exerciceService = service
        self.exercicesObservable = service.fetchExercices()
        super.init()
        
        bindExercices()
    }
    
    func bindExercices() {
        
        exercicesObservable.observe { [weak self] (promise) in
            Utils.printDebug(sender: self, message: "State: \(promise.state)")
            Utils.printDebug(sender: self, message: "Object: \(promise.object)")
            Utils.printDebug(sender: self, message: "Message: \(promise.message)")
        }
        
    }

}
