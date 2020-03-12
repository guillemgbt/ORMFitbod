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
    
    // For testing purposes
    case invalidWorkout = "workoutDataInvalidLine"
    case nonExistingWorkout = "nonExistingWorkout"
}


struct WorkoutComponents {
    let name: String
    let date: Date
    let sets: Int
    let reps: Int
    let weight: Int
}


/** EXAMPLE
 
 Oct 11 2017,Back Squat,1,10,45
 Oct 11 2017,Back Squat,1,10,135
 Oct 11 2017,Back Squat,1,3,185
 
 */


class WorkoutParser: NSObject {
    
    func parse(file: WorkoutFile = .workout1) -> PromiseObject<[Exercice]> {
        
        guard let stream = prepareStream(for: file) else {
            return PromiseObject(state: .error,
                                 object: nil,
                                 message: "Workout file not found.")
        }
        
        var exercices = [Exercice]()
            
        while let line = stream.nextLine() {
            
            guard let components = self.parseLine(line) else {
                Utils.printError(sender: self, message: "could not parse line \(line)")
                return PromiseObject(state: .error,
                                    object: nil,
                                    message: "Invalid workout file format.")
            }
            
            guard parseWorkoutComponents(components, exercices: &exercices) else {
                return PromiseObject(state: .error,
                                     object: nil,
                                     message: "Invalid workout values.")
            }
        }
            
        return PromiseObject(state: .success,
                             object: exercices)
    }
    
    internal func parseWorkoutComponents(_ components: WorkoutComponents, exercices: inout [Exercice]) -> Bool {
        
        if let exercice = exercices.filter({ $0.name == components.name }).first {
                
            if let dailyRecord = exercice.getRecord(for: components.date) {
                
                guard let unitRecord = unitRecordFrom(components) else {
                    Utils.printError(sender: self, message: "could not create exercice from components.")
                    return false
                }
                
                dailyRecord.addRecord(unitRecord)
                
            } else {
                guard let dailyRecord = dailyRecordFrom(components) else {
                    Utils.printError(sender: self, message: "could not create daily from components.")
                    return false
                }
                
                exercice.addRecord(dailyRecord)
            }
                
        } else {
            
            guard let exercice = exerciceFrom(components) else {
                Utils.printError(sender: self, message: "could not create exercice from components.")
                return false
            }
            
            exercices.append(exercice)
        }
        
        return true
    }
    
    private func prepareStream(for file: WorkoutFile) -> StreamReader? {
        
        if let filepath = Bundle.main.path(forResource: file.rawValue, ofType: "txt"),
            let url = URL(string: filepath) {
            
            return StreamReader(url: url)
        }
        print("Could not load workout file \(file.rawValue).txt")
        return nil
    }
    
    
    private func parseLine(_ line: String) -> WorkoutComponents? {
        let lineComponents = line.components(separatedBy: ",")
        
        guard let date = lineComponents[safe: 0]?.toDate(),
            let name = lineComponents[safe: 1],
            let sets = lineComponents[safe: 2]?.toInt(),
            let reps = lineComponents[safe: 3]?.toInt(),
            let weight = lineComponents[safe: 4]?.toInt() else {
                
                Utils.printError(sender: self, message: "Incorrect formatted workout unit found. ")
                
                return nil
        }
        
        return WorkoutComponents(name: name,
                                 date: date,
                                 sets: sets,
                                 reps: reps,
                                 weight: weight)
    }
    
    private func exerciceFrom(_ components: WorkoutComponents) -> Exercice? {
        guard let dailyRecord = self.dailyRecordFrom(components) else {
            return nil
        }
        return Exercice(name: components.name, record: dailyRecord)
    }
    
    private func dailyRecordFrom(_ components: WorkoutComponents) -> DailyRecord? {
        guard let unitRecord = self.unitRecordFrom(components) else {
            return nil
        }
        return DailyRecord(date: components.date, unitRecord: unitRecord)
    }
    
    private func unitRecordFrom(_ components: WorkoutComponents) -> UnitRecord? {
        return UnitRecord(sets: components.sets,
                          reps: components.reps,
                          weight: components.weight)
    }
    

}
