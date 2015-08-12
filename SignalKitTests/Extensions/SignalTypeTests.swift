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
        
        var result = 0
        
        chain = signal.map { $0 * 2 }.next { result = $0 }
        
        signal.dispatch(2)
        
        XCTAssertEqual(result, 4, "Should transform a signal of type T to signal of type U")
    }
}
