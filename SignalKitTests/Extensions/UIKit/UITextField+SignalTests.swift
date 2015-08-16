//
//  UITextField+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class UITextField_SignalTests: XCTestCase {
    
    var textField: MockTextField!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        textField = MockTextField()
        signalsBag = SignalBag()
    }
    
    func testObserveText() {
        
        var result = ""
        
        textField.observe().text
            .next { result = $0 }
            .addTo(signalsBag)
        
        textField.text = "John"
        textField.sendActionsForControlEvents(.EditingChanged)
        
        XCTAssertEqual(result, "John", "Should observe for text changes in UITextField")
    }
}
