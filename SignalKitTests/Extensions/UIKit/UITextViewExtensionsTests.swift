//
//  UITextViewExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITextViewExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveTextChanges() {
        
        var result = ""
        let textView = UITextView()
        let center = NotificationCenter.default
        
        textView.observe().text
            .next { result = $0 }
            .disposeWith(bag)
        
        textView.text = "John"
        center.post(name: NSNotification.Name.UITextViewTextDidChange, object: textView)
        
        XCTAssertEqual(result, "John", "Should observe the text changes in UITextView")
    }
}
