//
//  DisposableItemTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class DisposableItemTests: XCTestCase {
    
    func testCallDisposeAction() {
        
        var called = false
        
        let item = DisposableItem { called = true }
        
        item.dispose()
        
        XCTAssertEqual(called, true, "Should call the dispose action upon disposal")
    }
    
    func testDisposeOnlyOnce() {
        
        var counter = 0
        
        let item = DisposableItem { counter += 1 }
        
        item.dispose()
        item.dispose()
        
        XCTAssertEqual(counter, 1, "Should call the dispose action only once")
    }
}
