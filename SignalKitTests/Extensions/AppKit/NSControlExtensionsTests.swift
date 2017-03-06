//
//  NSControlExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/17.
//  Copyright © 2017 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NSControlExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveControlEvent() {
        
        let control = NSControl()
        var called = false
        
        control.observe().controlEvent
            .next { _ in called = true }
            .disposeWith(bag)
        
        NSApplication.shared().sendAction(control.action!, to: control.target, from: control)
        
        XCTAssertTrue(called)
    }
    
    func testBindToEnabledState() {
        
        let signal = Signal<Bool>()
        let control = NSControl()
        
        control.isEnabled = false
        
        signal.bindTo(enabledStateIn: control).disposeWith(bag)
        
        signal.send(true)
        
        XCTAssertTrue(control.isEnabled)
    }
}
