//
//  UITextFieldFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UITextFieldFunctionsTests: XCTestCase {

    var textField: MockTextField!
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        textField = MockTextField()
        signalContainer = SignalContainer()
    }
    
    func testObserveTextInTextField() {
        
        var result = ""
        
        observe(textIn: textField)
            .next { result = $0 }
            .addTo(signalContainer)
        
        textField.text = "Jack"
        textField.sendActionsForControlEvents(.EditingChanged)
        
        XCTAssertEqual(result, "Jack", "Should observe the text in UITextField")
    }
    
    func testObserveTextInTextFieldCurrentText() {
        
        var result = ""
        
        textField.text = "Jack"
        
        observe(textIn: textField)
            .next { result = $0 }
            .addTo(signalContainer)
        
        XCTAssertEqual(result, "Jack", "Should contain the current text from the UITextField")
    }
    
    func testBindToTextIn() {
        
        let name = ObservableOf<String>()
        
        name.dispatch("Jack")
        
        observe(name)
            .bindTo(textIn(textField))
            .addTo(signalContainer)
        
        XCTAssertEqual(textField.text, "Jack", "Should bind a String value to the text property of UITextField")
    }
    
    func testBindToAttributedTextIn() {
        
        let name = ObservableOf<NSAttributedString>()
        let attrText = NSAttributedString(string: "Jack")
        
        name.dispatch(attrText)
        
        observe(name)
            .bindTo(attributedTextIn(textField))
            .addTo(signalContainer)
        
        XCTAssertEqual(textField.attributedText!.string, "Jack", "Should bind a NSAttributedString to the attributedText property of UITextField")
    }
}
