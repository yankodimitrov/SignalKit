//
//  FunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class FunctionsTests: XCTestCase {

    let center = NSNotificationCenter.defaultCenter()
    let notificationName = "TestObserveForNotification"
    var person: Person!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "")
    }
    
    /// MARK: - Observe Observable
    
    func testObserveObservable() {
        
        let name = ObservableOf<String>()
        var result = ""
        
        let signal = observe(name) {
            result = $0
        }
        
        name.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should observe an observable")
    }
    
    func testObserveObservableWithoutCallback() {
        
        let name = ObservableOf<String>()
        
        let signal = observe(name)
        
        XCTAssertEqual(name.observersCount, 1, "Should observe an observable even without a callback")
    }
    
    func testObserveObservableWillDispose() {
        
        let name = ObservableOf<String>()
        var result = ""
        
        let signal = observe(name) {
            result = $0
        }
        
        signal.dispose()
        
        name.dispatch("John")
        
        XCTAssertEqual(result, "", "Should dispose the observation")
    }
    
    /// MARK: - Observe key path
    
    func testObserveKeyPath() {
        
        var name = ""
        
        let signal = observe(keyPath: "name", value: "", object: person) {
            
            name = $0
        }
        
        person.name = "Jack"
        
        XCTAssertEqual(name, "Jack", "Should observe a NSObject for the given key path")
    }
    
    func testObserveKeyPathCallbackCalled() {
        
        var name = ""
        
        let signal = observe(keyPath: "name", value: "", object: person) {
            
            name = $0
        }
        
        person.name = "Jack"
        
        XCTAssertEqual(name, "Jack", "Should call the observe key path callback")
    }
    
    func testObserveKeyPathDispose() {
        
        
        var name = ""
        
        let signal = observe(keyPath: "name", value: "", object: person) {
            
            name = $0
        }
        
        signal.dispose()
        
        person.name = "Jack"
        
        XCTAssertEqual(name, "", "Should dispose the observation")
    }
    
    /// MARK: - Observe for notification
    
    func testObserveNotification() {
        
        var result = NSNotification(name: "", object: nil)
        
        let signal = observe(notificationName) {
            
            result = $0
        }
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(result.name, notificationName, "Should observe the default notification center for notification")
    }
    
    func testObserveNotificationFromObject() {
        
        let person = Person(name: "John")
        var result = NSNotification(name: "", object: nil)
        
        let signal = observe(notificationName, fromObject: person) {
            result = $0
        }
        
        center.postNotificationName(notificationName, object: person)
        
        XCTAssertEqual(result.name, notificationName, "Should observe the default notification center for notification")
        XCTAssert(result.object === person, "Should observe for notification from certain object")
    }
    
    func testObserveNotificationCallback() {
        
        var called = false
        
        let signal = observe(notificationName){ _ in
            
            called = true
        }
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, true, "Should call the observe notification callback")
    }
    
    func testObserveNotificationDispose() {
        
        var called = false
        
        let signal = observe(notificationName){ _ in
            
            called = true
        }
        
        signal.dispose()
        
        center.postNotificationName(notificationName, object: nil)
        
        XCTAssertEqual(called, false, "Should dispose the observation")
    }
    
    func testObserveNotificationDispatchOnlyNewNotifications() {
        
        let notification = NSNotification(name: notificationName, object: nil)
        var result: NSNotification?
        
        let signal = observe(notificationName)
        
        center.postNotification(notification)
        
        let next = signal.addObserver {
            
            result = $0
        }
        
        XCTAssert(result == nil, "Should use a dispatch rule that never sends the latest received notification. We are interested only in newly received notifications")
    }
}
