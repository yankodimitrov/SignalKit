//
//  DisposableActionTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class DisposableActionTests: XCTestCase {
    
    func testCallDisposeActionUponDisposal() {
        
        var called = false
        
        let item = DisposableAction {
            called = true
        }
        
        item.dispose()
        
        XCTAssertEqual(called, true, "Should call the dispose action upon disposal")
    }
    
    func testCallDisposeActionOnlyOnce() {
        
        var counter = 0
        
        let item = DisposableAction {
            counter += 1
        }
        
        item.dispose()
        item.dispose()
        item.dispose()
        
        XCTAssertEqual(counter, 1, "Should call the dispose action only once upon disposal")
    }
}
