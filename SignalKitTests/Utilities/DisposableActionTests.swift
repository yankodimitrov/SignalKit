//
//  DisposableActionTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class DisposableActionTests: XCTestCase {
    
    func testDisposeAction() {
        
        var called = false
        
        let action = DisposableAction { called = true }
        
        action.dispose()
        
        XCTAssertTrue(called, "Should call the disposable action on dispose")
    }
    
    func testCallDisposeActionOnce() {
        
        var counter = 0
        
        let action = DisposableAction { counter += 1 }
        
        action.dispose()
        action.dispose()
        action.dispose()
        
        XCTAssertEqual(counter, 1, "Should dispose the action only once")
    }
}
