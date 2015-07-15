//
//  ControlObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class ControlObserverTests: XCTestCase {

    var control: MockControl!
    
    override func setUp() {
        super.setUp()
        
        control = MockControl()
    }
    
    func testObserve() {
        
        var called = false
        
        let observer = ControlObserver<MockControl>(observe: control, events: .ValueChanged) { _ in
            
            called = true
        }
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, true, "Should observe the control via target-action for the given events")
    }
    
    func testDispose() {
        
        var called = false
        
        let observer = ControlObserver<MockControl>(observe: control, events: .ValueChanged) { _ in
            
            called = true
        }
        
        observer.dispose()
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, false, "Should remove itself from the control's target-action observers")
    }
}
