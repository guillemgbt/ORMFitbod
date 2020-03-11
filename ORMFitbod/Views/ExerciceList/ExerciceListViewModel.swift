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
    
    init(service: ExerciceService = ExerciceService.shared) {
        self.exerciceService = service
    }
    
    func loadData() {
        exerciceService.fetchExercices()
    }

}
