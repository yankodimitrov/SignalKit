//
//  UIControlExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIControlExtensionsTests: XCTestCase {
    
    var control: MockControl!
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        control = MockControl()
        bag = DisposableBag()
    }
    
    func testObserveForEvent() {
        
        var called = false
        
        control.observe().events(.valueChanged)
            .next { _ in called = true }
            .disposeWith(bag)
        
        control.sendActions(for: .valueChanged)
        
        XCTAssertTrue(called, "Should observe the control for control events")
    }
    
    func testObserveForMultipleEvents() {
        
        var called = false
        
        control.observe().events([.valueChanged, .touchUpInside])
            .next { _ in called = true }
            .disposeWith(bag)
        
        control.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(called, "Should observe the control for multiple control events")
    }
    
    func testObserveOnlyTheSpecifiedEvents() {
        
        var called = false
        
        control.observe().events(.valueChanged)
            .next { _ in called = true }
            .disposeWith(bag)
        
        control.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(called, "Should observe only for the specified events")
    }
    
    func testBindToEnabled() {
        
        let signal = Signal<Bool>()
        
        control.isEnabled = true
        
        signal.bindTo(enabledStateIn: control).disposeWith(bag)
            
        signal.send(false)
        
        XCTAssertFalse(control.isEnabled, "Should bind a signal of boolean to the enabled property of UIControl")
    }
    
    func testObserveForTapEvent() {
        
        var called = false
        
        control.observe().tapEvent
            .next { _ in called = true }
            .disposeWith(bag)
        
        control.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(called, "Should observe the control for TouchUpInside events")
    }
}
