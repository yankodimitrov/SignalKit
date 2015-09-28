//
//  UILabel+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UILabel_SignalTests: XCTestCase {
    
    var label: UILabel!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        label = UILabel()
        signalsBag = SignalBag()
    }
    
    func testBindToText() {
        
        let signal = MockSignal<String>()
        
        signal.dispatch("Jack")
        
        signal.bindTo(textIn: label).addTo(signalsBag)
        
        XCTAssertEqual(label.text, "Jack", "Should bind a String value to the text property of UILabel")
    }
    
    func testBindToAttributedText() {
        
        let signal = MockSignal<NSAttributedString>()
        let attributedString = NSAttributedString(string: "Jack")
        
        signal.dispatch(attributedString)
        
        signal.bindTo(attributedTextIn: label).addTo(signalsBag)
        
        XCTAssertEqual(label.attributedText!, attributedString, "Should bind a NSAttributedString to the attributedText property of UILabel")
    }
}
