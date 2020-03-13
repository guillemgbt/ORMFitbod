//
//  WorkoutParserTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 12/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod


class WorkoutParserTests: XCTestCase {

    var parser: WorkoutParser!
    
    override func setUp() {
        parser = WorkoutParser()
    }


    func testParsingExsistingAndCorrectWorkoutFile() {
        
        let exercices = parser.parse()
        
        XCTAssertNotNil(exercices.object, "Must not be nil")
        XCTAssertFalse(exercices.object?.isEmpty ?? true, "Must have exdrcices")
        XCTAssertEqual(exercices.state, PromiseState.success)
    }
    
    
    func testParsingExsistingIncorrectWorkoutFile() {
       
        let exercices = parser.parse(file: .invalidWorkout)

        XCTAssertNil(exercices.object, "Must be nil")
        XCTAssertEqual(exercices.state, PromiseState.error)
    }
    
    func testParsingNonExistingWorkoutFile() {
        
        let exercices = parser.parse(file: .nonExistingWorkout)

        XCTAssertNil(exercices.object, "Must be nil")
        XCTAssertEqual(exercices.state, PromiseState.error)
    }
    
    func testParseCorrectWorkoutComponents() {
        
        let components = WorkoutComponents(name: "Press",
                                           date: Date(),
                                           sets: 3,
                                           reps: 4,
                                           weight: 10)
        
        var exercices = [Exercice]()
        
        let success = parser.parseWorkoutComponents(components, exercices: &exercices)
        
        XCTAssertTrue(success, "Must success")
        XCTAssertFalse(exercices.isEmpty, "Should parse exercice")
    }
    
    func testParseIncorrectWorkoutComponents() {
        
        let components = WorkoutComponents(name: "Press",
                                           date: Date(),
                                           sets: 3,
                                           reps: 0,
                                           weight: 10)
        
        var exercices = [Exercice]()
        
        let success = parser.parseWorkoutComponents(components, exercices: &exercices)
        
        XCTAssertFalse(success, "Must success")
        XCTAssertTrue(exercices.isEmpty, "Should parse exercice")
    }
    
    func testAddingSameDateAndExerciceRecord() {
        
        let components1 = WorkoutComponents(name: "Press",
                                           date: Date(timeIntervalSince1970: 100),
                                           sets: 3,
                                           reps: 1,
                                           weight: 10)
        
        let components2 = WorkoutComponents(name: "Press",
                                            date: Date(timeIntervalSince1970: 100),
                                            sets: 3,
                                            reps: 1,
                                            weight: 15)
        
        var exercices = [Exercice]()
        
        _ = parser.parseWorkoutComponents(components1, exercices: &exercices)
        _ = parser.parseWorkoutComponents(components2, exercices: &exercices)
        
        XCTAssertTrue(exercices.count == 1, "Should only parse one exercice")
        XCTAssertTrue(exercices.first?.getDailyRecords().count == 1,
                      "Should only parse one daily")

    }
    
    func testAddingDifferentDateAndSameExerciceRecord() {
        
        let components1 = WorkoutComponents(name: "Press",
                                           date: Date(timeIntervalSince1970: 100),
                                           sets: 3,
                                           reps: 1,
                                           weight: 10)
        
        let components2 = WorkoutComponents(name: "Press",
                                            date: Date(timeIntervalSince1970: 200),
                                            sets: 3,
                                            reps: 1,
                                            weight: 15)
        
        var exercices = [Exercice]()
        
        _ = parser.parseWorkoutComponents(components1, exercices: &exercices)
        _ = parser.parseWorkoutComponents(components2, exercices: &exercices)
        
        XCTAssertTrue(exercices.count == 1, "Should only parse one exercice")
        XCTAssertTrue(exercices.first?.getDailyRecords().count == 2,
                      "Should only parse one daily")

    }
    
    func testAddingDifferentExerciceRecord() {
        
        let components1 = WorkoutComponents(name: "Press",
                                           date: Date(timeIntervalSince1970: 100),
                                           sets: 3,
                                           reps: 1,
                                           weight: 10)
        
        let components2 = WorkoutComponents(name: "Squads",
                                            date: Date(timeIntervalSince1970: 100),
                                            sets: 3,
                                            reps: 1,
                                            weight: 15)
        
        var exercices = [Exercice]()
        
        _ = parser.parseWorkoutComponents(components1, exercices: &exercices)
        _ = parser.parseWorkoutComponents(components2, exercices: &exercices)
        
        XCTAssertTrue(exercices.count == 2, "Should only parse one exercice")

    }
    
}
