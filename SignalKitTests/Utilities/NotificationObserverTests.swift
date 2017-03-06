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

    let notificationName = Notification.Name.init("signalkit.notification")
    let center = NotificationCenter.default
    var observer: NotificationObserver!
    
    override func setUp() {
        super.setUp()
        
        observer = NotificationObserver(center: center, name: notificationName)
    }
    
    func testObserveForNotification() {
        
        var called = false
        
        observer.notificationCallback = { _ in
            
            called = true
        }
        
        center.post(name: notificationName, object: nil)
        
        XCTAssertTrue(called, "Should observe for notification")
    }
    
    func testDispose() {
        
        var called = false
        
        observer.notificationCallback = { _ in
            
            called = true
        }
        
        observer.dispose()
        
        center.post(name: notificationName, object: nil)
        
        XCTAssertFalse(called, "Should dispose the observation")
    }
    
    func testDisposeOnDeinit() {
        
        var observer: NotificationObserver? = NotificationObserver(center: center, name: notificationName)
        var called = false
        
        observer!.notificationCallback = { _ in
            
            called = true
        }
        
        observer = nil
        
        center.post(name: notificationName, object: nil)
        
        XCTAssertFalse(called, "Should dispose on deinit")
    }
}
