//
//  UIControlFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UIControlFunctionsTests: XCTestCase {

    var control: MockControl!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        control = MockControl()
        signalsBag = SignalBag()
    }
    
    /// MARK: Observe UIControl
    
    func testObserveControlForControlEvents() {
        
        var called = false
        
        observe(control, forEvents: .ValueChanged)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, true, "Should observe the UIControl for UIControlEvents")
    }
    
    func testObserveControlForControlEventsCallback() {
        
        var called = false
        
        let signal = observe(control, forEvents: .ValueChanged) {
            _ in
            
            called = true
        }
        
        control.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(called, true, "Should call the observation callback")
    }
    
    func testBindToIsEnabled() {
        
        let state = ObservableOf<Bool>()
        control.enabled = false
        
        observe(state)
            .bindTo(isEnabled(control))
            .addTo(signalsBag)
        
        state.dispatch(true)
        
        XCTAssertEqual(control.enabled, true, "Should bind a boolean value to the enabled state of UIControl")
    }
}
