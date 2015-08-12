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
    
    override func setUp() {
        super.setUp()
        
        signal = MockSignal<Int>()
    }
    
    func testNext() {
        
        var result = 0
        
        signal.next { result = $0 }
        
        signal.dispatch(2)
        
        XCTAssertEqual(result, 2, "Should add a new observer to the signal")
    }
}
