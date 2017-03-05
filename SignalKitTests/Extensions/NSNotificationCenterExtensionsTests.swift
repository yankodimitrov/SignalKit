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
    var center: NotificationCenter!
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        center = NotificationCenter.default
        bag = DisposableBag()
    }
    
    func testObserveNotification() {
        
        var called = false
        
        center.observe().notification(notificationName)
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: Notification.Name(rawValue: notificationName), object: nil)
        
        XCTAssertEqual(called, true, "Should observe for notification posted on the notification center")
    }
    
    func testObserveNotificationFromObject() {
        
        let person = Person(name: "")
        var called = false
        
        center.observe().notification(notificationName, fromObject: person)
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: Notification.Name(rawValue: notificationName), object: person)
        
        XCTAssertEqual(called, true, "Should observe for notification posted on the notification center from a certain object")
    }
    
    func testObserveOnlyTheSpecifiedNotificationName() {
        
        var called = false
        
        center.observe().notification(notificationName)
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: Notification.Name(rawValue: "other.notification"), object: nil)
        
        XCTAssertEqual(called, false, "Should observe only for the specified notification")
    }
}
