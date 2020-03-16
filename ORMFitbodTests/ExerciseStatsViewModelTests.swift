//
//  ExerciseStatsViewModelTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 16/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod


class ExerciseStatsViewModelTests: XCTestCase {

    var viewModel: ExerciseStatsViewModel!
    
    override func setUp() {
        viewModel = ExerciseStatsViewModel(exercise: testExercice())
    }
    
    func testAsyncChartSetUp() {
        
        viewModel.prepareChartInBackground(bounds: CGRect.zero)
        
        XCTAssertNil(viewModel.chart.current(), "Nil at creation trigger")
        waitForResponse()
        XCTAssertNotNil(viewModel.chart.current(), "Eventually must load chard given an exercise")
    }
    
    func test1RMChartLimits() {
        
        let (min, max) = viewModel.oneRepMaxLimits()
        
        let oneRMs = testExercice().getDailyRecords().map({ $0.get1RM() })
                
        oneRMs.forEach { (oneRM) in
            XCTAssertLessThan(Float(min), oneRM)
            XCTAssertGreaterThan(Float(max), oneRM)
        }
    }
    
    private func testExercice() -> Exercise {
        
        let daily1 = DailyRecord(date: Date(timeIntervalSince1970: 100),
                                 unitRecord: UnitRecord(sets: 1,
                                                        reps: 3,
                                                        weight: 23)!)

        let daily2 = DailyRecord(date: Date(),
                                 unitRecord: UnitRecord(sets: 1,
                                                        reps: 1,
                                                        weight: 10)!)
        let exercise = Exercise(name: "Press",
                                record: daily1)!
        
        exercise.addRecord(daily2)
        
        return exercise
    }
    
    private func waitForResponse() {
        let exp = expectation(description: "processing time")

        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
           exp.fulfill()
        }
        wait(for: [exp], timeout: 1.2)
    }
}
