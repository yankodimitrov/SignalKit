//
//  SpinLockTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class SpinLockTests: XCTestCase {
    
    var lock: SpinLock!
    
    override func setUp() {
        super.setUp()
        
        lock = SpinLock()
    }
    
    func testLock() {
        
        lock.lock()
        
        let result = withUnsafeMutablePointer(&lock.spinlock, OSSpinLockTry)
        
        XCTAssertEqual(result, false, "Should lock the spin lock")
    }
    
    func testUnlock() {
        
        lock.unlock()
        
        let result = withUnsafeMutablePointer(&lock.spinlock, OSSpinLockTry)
        
        XCTAssertEqual(result, true, "Should unlock the spin lock")
    }
}
