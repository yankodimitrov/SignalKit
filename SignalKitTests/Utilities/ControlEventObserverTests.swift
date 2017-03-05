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
    
    var control: MockControl!
    
    override func setUp() {
        super.setUp()
        
        control = MockControl()
    }
    
    func testObserveControlEvents() {
        
        let observer = ControlEventObserver(control: control, events: .valueChanged)
        var called = false
        
        observer.eventCallback = { _ in called = true }
        
        control.sendActions(for: .valueChanged)
        
        XCTAssertTrue(called, "Should observe the UIControl for UIControl events")
    }
    
    func testDispose() {
        
        let observer = ControlEventObserver(control: control, events: .valueChanged)
        var called = false
        
        observer.eventCallback = { _ in called = true }
        observer.dispose()
        
        control.sendActions(for: .valueChanged)
        
        XCTAssertFalse(called, "Should dispose the observation")
    }
    
    func testDisposeOnDeinit() {
        
        var observer: ControlEventObserver? = ControlEventObserver(control: control, events: .valueChanged)
        var called = false
        
        observer!.eventCallback = { _ in called = true }
        observer = nil
        
        control.sendActions(for: .valueChanged)
        
        XCTAssertFalse(called, "Should dispose on deinit")
        
    }
}
