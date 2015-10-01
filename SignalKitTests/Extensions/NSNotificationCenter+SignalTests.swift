//
//  NSNotificationCenter+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NSNotificationCenter_SignalTests: XCTestCase {
    
    let center = NSNotificationCenter.defaultCenter()
    let notificationName = "TestNotificationName"
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        signalsBag = DisposableBag()
    }
    
    func testObserveNotificationName() {
        
        var called = false
        
        center.observe()
            .notification(notificationName)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, true, "Should observe notification center for a given notification")
    }
    
    func testObserveNotificationFromObject() {
        
        let person = Person(name: "")
        var called = false
        
        center.observe()
            .notification(notificationName, fromObject: person)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(notificationName, object: person)
        
        XCTAssertEqual(called, true, "Should observe for a notification from a given object")
    }
}
