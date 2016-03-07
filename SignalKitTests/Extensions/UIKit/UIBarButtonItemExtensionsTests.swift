//
//  UIBarButtonItemExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIBarButtonItemExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveTapEvent() {
        
        let item = UIBarButtonItem()
        var called = false
        
        item.observe().tapEvent
            .next { _ in called = true }
            .disposeWith(bag)
        
        item.target?.performSelector(item.action, withObject: item)
        
        XCTAssertTrue(called, "Should observe the tap action in UIBarButtonItem")
    }
}
