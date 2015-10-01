//
//  UITextField+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITextField_SignalTests: XCTestCase {
    
    var textField: MockTextField!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        textField = MockTextField()
        signalsBag = DisposableBag()
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
    
    func testObserveCurrentText() {
        
        var result = ""
        
        textField.text = "John"
        
        textField.observe().text
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, "John", "Should dispatch the current text in UITextField")
    }
}
