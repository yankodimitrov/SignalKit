//
//  NSIndexSet+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NSIndexSet_SignalTests: XCTestCase {
    
    func testInitWithSet() {
        
        let set = Set<Int>([1, 2, 3])
        let indexSet = NSIndexSet(withSet: set)
        
        XCTAssertEqual(indexSet.containsIndexesInRange(NSRange(1...3)), true, "Should contain the values in the set")
    }
}
