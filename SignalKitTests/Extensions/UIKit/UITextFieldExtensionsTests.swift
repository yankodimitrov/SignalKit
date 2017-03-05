//
//  UITextFieldExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITextFieldExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveTextChanges() {
        
        let field = MockTextField()
        var result = ""
        
        field.observe().text
            .next { result = $0 }
            .disposeWith(bag)
        
        field.text = "John"
        field.sendActions(for: .editingChanged)
        
        XCTAssertEqual(result, "John", "Should observe the text changes in UITextField")
    }
}
