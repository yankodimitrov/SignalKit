//
//  NotificationObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class NotificationObserverTests: XCTestCase {

    let notificationName = "TestNotificationObserverNotification"
    var center = NSNotificationCenter.defaultCenter()
    
    func testObserve() {
        
        var called = false
        
        let observer = NotificationObserver(observe: notificationName) {
            notification in
            
            called = true
        }
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, true, "Should observe the default notification center for a notification")
    }
    
    func testDispose() {
        
        var called = false
        
        let observer = NotificationObserver(observe: notificationName) {
            notification in
            
            called = true
        }
        
        observer.dispose()
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, false, "Should remove the notification observation upon disposal")
    }
}
