//
//  NSNotificationCenterExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NSNotificationCenterExtensionsTests: XCTestCase {
    
    let notificationName = "signalkit.notification"
    var center: NSNotificationCenter!
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        center = NSNotificationCenter.defaultCenter()
        bag = DisposableBag()
    }
    
    func testObserveNotification() {
        
        var called = false
        
        center.observe().notification(notificationName)
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for notification posted on the notification center")
    }
    
    func testObserveNotificationFromObject() {
        
        let person = Person(name: "")
        var called = false
        
        center.observe().notification(notificationName, fromObject: person)
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.postNotificationName(notificationName, object: person)
        
        XCTAssertEqual(called, true, "Should observe for notification posted on the notification center from a certain object")
    }
}
