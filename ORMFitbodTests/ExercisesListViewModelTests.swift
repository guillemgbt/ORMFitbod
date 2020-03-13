//
//  ExercisesListViewModelTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 13/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod

class ExercisesListViewModelTests: XCTestCase {

    fileprivate var mockService: ExerciseServiceMock!
    var viewModel: ExerciseListViewModel!
    
    override func setUp() {
        mockService = ExerciseServiceMock()
        viewModel = ExerciseListViewModel(service: mockService)
    }
    
    func testLoadingWhenRequest() {
                
        XCTAssertTrue(viewModel.isLoading.current(), "Must be loading when requesting exercises.")
        XCTAssertTrue(viewModel.exercisesUpdate.current(), "Must trigger updates in exercise promise.")
    }
    
    func testLoadingWhenRequestSucceed() {
        
        mockService.fail = false
        
        let exp = expectation(description: "processing time")
        
        var triggerCount = 0
        viewModel.exercisesUpdate.observe { (trigger) in
            if trigger { triggerCount+=1 }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.2)
        XCTAssertFalse(viewModel.isLoading.current(), "Must not be loading.")
        XCTAssertNil(viewModel.message.current(), "Must not report error message.")
        XCTAssertEqual(triggerCount, 2, "Must have triggered two times.")
    }
    
    func testLoadingWhenRequestFailed() {
        
        mockService.fail = true
        
        let exp = expectation(description: "processing time")
        
        var triggerCount = 0
        viewModel.exercisesUpdate.observe { (trigger) in
            if trigger { triggerCount+=1 }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.2)
        XCTAssertFalse(viewModel.isLoading.current(), "Must not be loading.")
        XCTAssertNotNil(viewModel.message.current(), "Must report error message.")
        XCTAssertEqual(triggerCount, 2, "Must have triggered two times.")
    }


}

fileprivate class ExerciseServiceMock: ExerciseService {
    
    var fail: Bool = false
    
    override func fetchExercises() -> SimpleObservable<PromiseObject<[Exercise]>> {
        
        let loading = PromiseObject<[Exercise]>(state: .loading)
        let observable = SimpleObservable(value: loading)
        
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
   
            let result = PromiseObject<[Exercise]>(state: self.fail ? .error : .success,
                                                   object: self.fail ? nil : [Exercise](),
                                                   message: self.fail ? "Error" : nil)
            
            observable.accept(result)
        }
        
        return observable
    }
    
}
