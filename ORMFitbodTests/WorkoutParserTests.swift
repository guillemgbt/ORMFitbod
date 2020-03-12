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
        
    }
}
