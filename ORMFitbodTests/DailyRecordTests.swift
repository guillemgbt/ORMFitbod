//
//  DailyRecordTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 12/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod

class DailyRecordTests: XCTestCase {
    
    var high1RMUnit: UnitRecord!
    var low1RMUnit: UnitRecord!

    override func setUp() {
        high1RMUnit = UnitRecord(sets: 1, reps: 20, weight: 20)
        low1RMUnit = UnitRecord(sets: 1, reps: 10, weight: 10)
    }

    func testAddingHigherUnit1RM() {
        
        let dailyRecord = DailyRecord(date: Date(), unitRecord: low1RMUnit)
        dailyRecord.addRecord(high1RMUnit)
        
        XCTAssertEqual(dailyRecord.get1RM(), high1RMUnit.get1RM())
        
    }
    
    func testAddingLowerUnit1RM() {
        
        let dailyRecord = DailyRecord(date: Date(), unitRecord: high1RMUnit)
        dailyRecord.addRecord(low1RMUnit)
        
        XCTAssertEqual(dailyRecord.get1RM(), high1RMUnit.get1RM())
    }
}
