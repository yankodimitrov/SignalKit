//
//  UILabelExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UILabelExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testBindToText() {
        
        let signal = Signal<String>()
        let label = UILabel()
        
        label.text = ""
        
        signal.bindTo(textIn: label).disposeWith(bag)
        
        signal.send("John")
        
        XCTAssertEqual(label.text, "John", "Should bind the string value to the text property of UILabel")
    }
}
