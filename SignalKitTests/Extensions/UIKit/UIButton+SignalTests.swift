//
//  UIButton+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class UIButton_SignalTests: XCTestCase {
    
    var button: MockButton!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        button = MockButton()
        signalsBag = SignalBag()
    }
    
    func testObserveTapEvents() {
        
        var called = false
        
        button.observe().tapEvent
            .next { _ in called = true }
            .addTo(signalsBag)
        
        button.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertEqual(called, true, "Should observe the button for touch up inside events")
    }
}
