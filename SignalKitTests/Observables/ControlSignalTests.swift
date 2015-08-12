//
//  ControlSignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class ControlSignalTests: XCTestCase {

    var control: MockControl!
    
    override func setUp() {
        super.setUp()
        
        control = MockControl()
    }
    
    func testObserveControlForControlEvents() {
        
        let signal = ControlSignal<MockControl>(control: control, events: .ValueChanged)
        var called = false
        
        signal.addObserver { _ in called = true }
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, true, "Should observe UIControl for control events")
    }
    
    func testDispose() {
        
        let signal = ControlSignal<MockControl>(control: control, events: .ValueChanged)
        var called = false
        
        signal.addObserver { _ in called = true }
        signal.dispose()
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, false, "Should dispose the observation")
    }
}
