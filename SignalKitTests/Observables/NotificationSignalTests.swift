//
//  NotificationSignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class NotificationSignalTests: XCTestCase {
    
    let center = NSNotificationCenter.defaultCenter()
    let notificationName = "TestNotification"
    
    func testObserveForNotification() {
        
        let signal = NotificationSignal(notificationName: notificationName)
        var called = false
        
        signal.addObserver { _ in called = true }
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for a given notification name")
    }
    
    func testObserveForNotificationFromObject() {
        
        let person = Person(name: "Jack")
        let signal = NotificationSignal(notificationName: notificationName, fromObject: person)
        var called = false
        
        signal.addObserver { _ in called = true }
        
        center.postNotificationName(notificationName, object: person)
        
        XCTAssertEqual(called, true, "Should observe for a given notification send by a certain object")
        
    }
    
    func testDispose() {
        
        let signal = NotificationSignal(notificationName: notificationName)
        var called = false
        
        signal.addObserver { _ in called = true }
        signal.dispose()
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, false, "Should dispose the observation")
    }
}
