//
//  WorkoutParser.swift
//  ORMFitbod
//
//  Created by Guillem Budia Tirado on 10/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

enum WorkoutFile: String {
    case workout1 = "workoutData1"
}

class WorkoutParser: NSObject {
    
    func parse(file: WorkoutFile = .workout1) {
        
        guard let stream = prepareStream(for: file) else {
            return //RequestObject(nil, error, message)
        }
            
        while let line = stream.nextLine() {
            print(line)
        }
    }
    
    private func prepareStream(for file: WorkoutFile) -> StreamReader? {
        
        if let filepath = Bundle.main.path(forResource: file.rawValue, ofType: "txt"),
            let url = URL(string: filepath) {
            
            return StreamReader(url: url)
        }
        print("Could not load workout file \(file.rawValue).txt")
        return nil
    }

}
