//
//  ExerciceTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 12/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod


class ExerciceTests: XCTestCase {

    var high1RMDailyRecord: DailyRecord!
    var low1RMDailyRecord: DailyRecord!

    override func setUp() {
        high1RMDailyRecord = DailyRecord(date: Date(),
                                         unitRecord: UnitRecord(sets: 1,
                                                                reps: 20,
                                                                weight: 20)!)
        
        low1RMDailyRecord = DailyRecord(date: Date(timeIntervalSince1970: 100),
                                        unitRecord: UnitRecord(sets: 1,
                                                               reps: 10,
                                                               weight: 10)!)
    }

    
    func testInitWithInvalidValues() {
        
        let exercice = Exercise(name: "",
                                record: low1RMDailyRecord)
        
        XCTAssertNil(exercice, "Exercice should not initialise with empty name")
    }
    
    func testWithValidValues() {
        
        let exercice = Exercise(name: "Press",
                                record: low1RMDailyRecord)
        
        XCTAssertNotNil(exercice, "Exercice should initialise with empty name")
    }
    
    func testAddingLow1RM() {
        
        let exercice = Exercise(name: "Press",
                                record: low1RMDailyRecord)
        
        exercice?.addRecord(high1RMDailyRecord)
        
        XCTAssertEqual(exercice?.get1RM(), high1RMDailyRecord.get1RM())
    }
    
    func testAddingHigh1RM() {
        
        let exercice = Exercise(name: "Press",
                                record: high1RMDailyRecord)
        
        exercice?.addRecord(low1RMDailyRecord)
        
        XCTAssertEqual(exercice?.get1RM(), high1RMDailyRecord.get1RM())
    }
    
    func testGetExistingDaily() {
        
        let exercice = Exercise(name: "Press",
                                record: high1RMDailyRecord)
        exercice?.addRecord(low1RMDailyRecord)
        
        let daily = exercice?.getRecord(for: Date(timeIntervalSince1970: 100))
        
        XCTAssertNotNil(daily)
    }
    
    func testGetNotExistingDaily() {
        
        let exercice = Exercise(name: "Press",
                                record: high1RMDailyRecord)
        exercice?.addRecord(low1RMDailyRecord)
        
        let daily = exercice?.getRecord(for: Date(timeIntervalSince1970: 1000))
        
        XCTAssertNil(daily)
        
    }

}
