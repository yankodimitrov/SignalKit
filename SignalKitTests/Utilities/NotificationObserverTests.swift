//
//  NotificationObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class NotificationObserverTests: XCTestCase {

    let notificationName = "signalkit.notification"
    
    func testObserveForNotification() {
        
        let center = NSNotificationCenter.defaultCenter()
        let observer = NotificationObserver(center: center, name: notificationName)
        var called = false
        
        observer.notificationCallback = { _ in
            
            called = true
        }
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for notification")
    }
    
    func testDispose() {
        
        let center = NSNotificationCenter.defaultCenter()
        let observer = NotificationObserver(center: center, name: notificationName)
        var called = false
        
        observer.notificationCallback = { _ in
            
            called = true
        }
        
        observer.dispose()
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, false, "Should dispose the observation")
    }
}
