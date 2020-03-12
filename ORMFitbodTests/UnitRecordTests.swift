//
//  UnitRecordTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod

class UnitRecordTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}
    
    func testInitWithValidValues() {
        
        let record = UnitRecord(sets: 1, reps: 5, weight: 20)
        
        XCTAssertNotNil(record, "With valid values UnitRecord must initialise.")
    }
    
    func testInitWithInvalidValues() {
        
        let record = UnitRecord(sets: 1, reps: 10, weight: -20)
        
        XCTAssertNil(record, "With invalid values UnitRecord must not initialise.")
    }

    
}
