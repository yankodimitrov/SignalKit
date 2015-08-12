//
//  ObservableTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class ObservableTests: XCTestCase {
    
    var userName: MockObservable<String>!
    
    override func setUp() {
        super.setUp()
        
        userName = MockObservable<String>()
    }
    
    func testAddObserver() {
        
        var result = ""
        
        userName.addObserver { result = $0 }
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should add observer")
    }
    
    func testDisposeObserver() {
        
        var result = ""
        let disposable = userName.addObserver { result = $0 }
        
        disposable.dispose()
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, "", "Should dispose the observer")
    }
    
    func testDispatch() {
        
        var resultOne = ""
        var resultTwo = ""
        
        userName.addObserver { resultOne = $0 }
        userName.addObserver { resultTwo = $0 }
        
        userName.dispatch("Jack")
        
        XCTAssertEqual(resultOne, "Jack", "Should dispatch the value to all observers")
        XCTAssertEqual(resultTwo, "Jack", "Should dispatch the value to all observers")
    }
    
    func testRemoveObservers() {
        
        var result = ""
        
        userName.addObserver { result = $0 }
        userName.removeObservers()
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, "", "Should remove all observers")
    }
    
    func testObserve() {
        
        let signal = userName.observe()
        var result = ""
        
        signal.addObserver { result = $0 }
        
        userName.dispatch("Jack")
        
        XCTAssertEqual(result, "Jack", "Should return a signal that can be used to form a chain of operations on the upcoming changes in the observable")
    }
}
