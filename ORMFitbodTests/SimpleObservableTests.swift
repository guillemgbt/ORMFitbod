//
//  SimpleObservableTests.swift
//  ORMFitbodTests
//
//  Created by Guillem Budia Tirado on 11/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import XCTest
@testable import ORMFitbod

class SimpleObservableTests: XCTestCase {
    
    var observable: SimpleObservable<Bool>!
    var boolTest: Bool?

    override func setUp() {
        observable = SimpleObservable<Bool>(value: false)
        boolTest = nil
    }

    override func tearDown() {}
    
    func testObservableAtInitialObservation() {
                
        observable.observe { [weak self] (flag) in
            self?.boolTest = flag
        }
        
        XCTAssertNotNil(boolTest, "observe clousure has to be called at the moment of set up.")
    }
    
    func testObservableAtChange() {
        
        observable.observe { [weak self] (flag) in
            self?.boolTest = flag
        }
        
        observable.accept(true)
        
        XCTAssertTrue(self.boolTest ?? false, "clousure must be called and update variable.")
    }
    
    func testObservableAtMainThread() {
        
        let expect = expectation(description: "signal in background thread")

        
        observable.observeInUI { [weak self] (flag) in
            //To ensure we are checking "true" trigger and main thread
            self?.boolTest = Thread.isMainThread && flag
            
            if self?.boolTest ?? false { expect.fulfill() }
        }
        
        DispatchQueue.global().async {
            self.observable.accept(true)
        }

        wait(for: [expect], timeout: 1)
        XCTAssertTrue(self.boolTest ?? false, "observeInUI must run on the main thread.")
    }

    

}
