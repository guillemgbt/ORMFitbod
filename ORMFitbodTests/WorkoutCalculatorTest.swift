//
//  WorkoutCalculatorTest.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod

class WorkoutCalculatorTest: XCTestCase {

    override func setUp() {}

    override func tearDown() {}
    

    func test1RMCalculation() {
        let reps = 10
        let weight = 20
        let desiredResult = Float(26.666666)
        
        let result = try? WorkoutCalculator.compute1RM(weight: weight, reps: reps)
                
        XCTAssertEqual(result ?? 0.0, desiredResult, "Result do not match.")
    }
    
    func test1RMWrongInput() {
        
        let reps = 0
        let weight = -4
                        
        XCTAssertThrowsError(try WorkoutCalculator.compute1RM(weight: weight, reps: reps),
                             "With wrong inputs it must throw error") { (error) in}
    }
    
    func test1RMValidInput() {
        
        let reps = 10
        let weight = 20
        
        XCTAssertNoThrow(try WorkoutCalculator.compute1RM(weight: weight, reps: reps),
                         "With valit input it should not throw error.")
    }

}
