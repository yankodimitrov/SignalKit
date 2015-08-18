//
//  UIControl+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class UIControl_SignalTests: XCTestCase {

    var control: MockControl!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        control = MockControl()
        signalsBag = SignalBag()
    }
    
    func testObserveControlEvent() {
        
        var called = false
        
        control.observe()
            .events(.ValueChanged)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, true, "Should observe the control for UIControlEvents")
    }
    
    func testObserveMultipleControlEvents() {
        
        var called = false
        
        control.observe()
            .events([.ValueChanged, .TouchUpInside])
            .next { _ in called = true }
            .addTo(signalsBag)
        
        control.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertEqual(called, true, "Should observe the control for multiple UIControlEvents")
    }
    
    func testBindToEnabled() {
        
        let signal = MockSignal<Bool>()
        
        control.enabled = true
        
        signal
            .bindTo(enabled: control)
            .addTo(signalsBag)
        
        signal.dispatch(false)
        
        XCTAssertEqual(control.enabled, false, "Should bind a boolean signal to the enabled property of UIControl")
    }
}
