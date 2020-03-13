//
//  ExerciceServiceTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 12/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod


class ExerciceServiceTests: XCTestCase {

    override func setUp() {}
    
    func testLoadingOnFetch() {
        let workoutParser = WorkoutParserMock()
        workoutParser.workoutFile = .workout1
        let service = ExerciseService(parser: workoutParser)
        
        let observable = service.fetchExercises()
        
        XCTAssertEqual(observable.current().state, .loading, "Must be loading at first time.")
    }

    func testFetchValidWorkout() {
        let workoutParser = WorkoutParserMock()
        workoutParser.workoutFile = .workout1
        let service = ExerciseService(parser: workoutParser)
        
        let obesvable = service.fetchExercises()
        
        var triggers = 0
        let expect = expectation(description: "signal in background thread")
        obesvable.observe { (promisedExercices) in
            triggers+=1
            
            if triggers == 2 {
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1)
        XCTAssertEqual(obesvable.current().state, .success)
        XCTAssertFalse(obesvable.current().object?.isEmpty ?? true, "Must have exercices")

    }
    
    func testFetchInalidWorkout() {
        let workoutParser = WorkoutParserMock()
        workoutParser.workoutFile = .invalidWorkout
        let service = ExerciseService(parser: workoutParser)
        
        let obesvable = service.fetchExercises()
        
        var triggers = 0
        let expect = expectation(description: "signal in background thread")
        obesvable.observe { (promisedExercices) in
            triggers+=1
            
            if triggers == 2 {
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1)
        XCTAssertEqual(obesvable.current().state, .error)
        XCTAssertNil(obesvable.current().object, "Must not have exercices")
    }
    
    func testFetchNotExistingWorkout() {
        let workoutParser = WorkoutParserMock()
        workoutParser.workoutFile = .nonExistingWorkout
        let service = ExerciseService(parser: workoutParser)
        
        let obesvable = service.fetchExercises()
        
        var triggers = 0
        let expect = expectation(description: "signal in background thread")
        obesvable.observe { (promisedExercices) in
            triggers+=1
            
            if triggers == 2 {
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1)
        XCTAssertEqual(obesvable.current().state, .error)
        XCTAssertNil(obesvable.current().object, "Must not have exercices")
    }


}

class WorkoutParserMock: WorkoutParser {
    
    var workoutFile: WorkoutFile!
    
    override func parse(file: WorkoutFile = .workout1) -> PromiseObject<[Exercise]> {
        return super.parse(file: workoutFile)
    }
    
}
