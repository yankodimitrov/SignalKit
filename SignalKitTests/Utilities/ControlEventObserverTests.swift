//
//  ControlEventObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class ControlEventObserverTests: XCTestCase {
    
    func testObserveControlEvents() {
        
        let control = MockControl()
        let observer = ControlEventObserver(control: control, events: .ValueChanged)
        var called = false
        
        observer.eventCallback = { _ in called = true }
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, true, "Should observe the UIControl for UIControl events")
    }
    
    func testDispose() {
        
        let control = MockControl()
        let observer = ControlEventObserver(control: control, events: .ValueChanged)
        var called = false
        
        observer.eventCallback = { _ in called = true }
        observer.dispose()
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, false, "Should dispose the observation")
    }
}
