//
//  SignalValueTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class SignalValueTests: XCTestCase {
    
    func testInitWithValue() {
        
        let signal = SignalValue(value: "John")
        
        XCTAssertEqual(signal.value, "John", "Should init with value")
    }
    
    func testSendValueWhenChanged() {
        
        let signal = SignalValue(value: 1)
        var result = 0
        
        signal.addObserver { result = $0 }
        signal.value = 8
        
        XCTAssertEqual(result, 8, "Should send the value on value change")
    }
    
    func testSendCurrentValueWhenNewObserverIsAdded() {
        
        let signal = SignalValue(value: "John")
        var result = ""
        
        signal.next { result = $0 }
        
        XCTAssertEqual(result, "John", "Should send the current value to new observers")
    }
    
    func testSendNext() {
        
        let signal = SignalValue(value: 2)
        var result = 0
        
        signal.next { result = $0 }
        signal.send(3)
        
        XCTAssertEqual(result, 3, "Should send the new value")
        XCTAssertEqual(signal.value, 3, "Should change the current value")
    }
}
