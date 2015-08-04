//
//  UIButtonFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UIButtonFunctionsTests: XCTestCase {

    var button: MockButton!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        button = MockButton()
        signalsBag = SignalBag()
    }
    
    func testObserveTouchUpInside() {
        
        var called = false
        
        observe(touchUpInside: button)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        button.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertEqual(called, true, "Should observe UIButton for .TouchUpInside control event")
    }
}
