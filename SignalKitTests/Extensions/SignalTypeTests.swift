//
//  SignalTypeTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class SignalTypeTests: XCTestCase {
    
    var signal: MockSignal<Int>!
    var chain: Disposable?
    
    override func setUp() {
        super.setUp()
        
        signal = MockSignal<Int>()
        chain = nil
    }
    
    func testNext() {
        
        var result = 0
        
        signal.next { result = $0 }
        
        signal.dispatch(2)
        
        XCTAssertEqual(result, 2, "Should add a new observer to the signal")
    }
    
    func testMap() {
        
        let signal = MockSignal<String>()
        var result = 0
        
        chain = signal.map { $0.characters.count }.next { result = $0 }
        
        signal.dispatch("John")
        
        XCTAssertEqual(result, 4, "Should transform a signal of type T to signal of type U")
    }
    
    func testFilter() {
        
        var result = 0
        
        chain = signal.filter { $0 > 3 }.next { result = $0 }
        
        signal.dispatch(1)
        signal.dispatch(2)
        signal.dispatch(3)
        signal.dispatch(44)
        
        XCTAssertEqual(result, 44, "Should dispatch only the value that matches the filter predicate")
    }
    
    func testSkip() {
        
        var result = 0
        
        chain = signal.skip(2).next { result = $0 }
        
        signal.dispatch(11)
        signal.dispatch(22)
        signal.dispatch(33)
        
        XCTAssertEqual(result, 33, "Should skip a certain number of dispatched values")
    }
}
