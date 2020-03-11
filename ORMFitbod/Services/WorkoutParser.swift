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


/** EXAMPLE
 
 Oct 11 2017,Back Squat,1,10,45
 Oct 11 2017,Back Squat,1,10,135
 Oct 11 2017,Back Squat,1,3,185
 
 */

class WorkoutParser: NSObject {
    
    func parse(file: WorkoutFile = .workout1) {
        
        guard let stream = prepareStream(for: file) else {
            return //RequestObject(nil, error, message)
        }
            
        while let line = stream.nextLine()?.components(separatedBy: ",") {
            
            guard let date = line[safe: 0]?.toDate(),
                let name = line[safe: 1],
                let sets = line[safe: 1]?.toInt(),
                let reps = line[safe: 1]?.toInt(),
                let weight = line[safe: 1]?.toInt() else {
                    
                    Utils.printError(sender: self, message: "Incorrect formatted workout unit found. ")
                    
                    return
            }
            
            
            
            
            
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
