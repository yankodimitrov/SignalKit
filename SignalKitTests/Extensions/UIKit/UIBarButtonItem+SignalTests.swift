//
//  UIBarButtonItem+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIBarButtonItem_SignalTests: XCTestCase {
    
    var button: UIBarButtonItem!
    var disposableBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        button = UIBarButtonItem()
        disposableBag = DisposableBag()
    }
    
    func testObserveTapEvent() {
        
        var isCalled = false
        
        button.observe().tapEvent
            .next { _ in isCalled = true }
            .disposeWith(disposableBag)
        
        button.target?.performSelector(button.action, withObject: button)
        
        XCTAssertEqual(isCalled, true, "Should observe UIBarButtonItem for tap event")
    }
}
