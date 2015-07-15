//
//  UILabelFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UILabelFunctionsTests: XCTestCase {

    var label: UILabel!
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        label = UILabel()
        signalContainer = SignalContainer()
    }
    
    func testBindToTextIn() {
        
        let name = ObservableOf<String>()
        
        name.dispatch("Jack")
        
        observe(name)
            .bindTo(textIn(label))
            .addTo(signalContainer)
        
        XCTAssertEqual(label.text!, "Jack", "Should bind a String value to the text property of UILabel")
    }
    
    func testBindToAttributedTextIn() {
        
        let name = ObservableOf<NSAttributedString>()
        let attrText = NSAttributedString(string: "Jack")
        
        name.dispatch(attrText)
        
        observe(name)
            .bindTo(attributedTextIn(label))
            .addTo(signalContainer)
        
        XCTAssertEqual(label.attributedText!, attrText, "Should bind a NSAttributedString to the attributedText property of UILabel")
    }
}
