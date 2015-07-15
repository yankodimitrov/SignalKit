//
//  ObservableValueTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class ObservableValueTests: XCTestCase {

    var initialValue = ""
    var userName: ObservableValue<String>!
    var lock: MockLock!
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        lock = MockLock()
        userName = ObservableValue<String>(value: initialValue, lock: lock)
        signalContainer = SignalContainer()
    }
    
    func testAddObserver() {
        
        userName.addObserver { _ in }
        
        XCTAssertEqual(userName.observersCount, 1, "Should add observer")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testRemoveObserver() {
        
        let observer = userName.addObserver { _ in }
        
        lock.lockCalled = false
        lock.unlockCalled = false
        
        observer.dispose()
        
        XCTAssertEqual(userName.observersCount, 0, "Should remove the observer")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testDispatch() {
        
        var result = ""
        
        userName.addObserver { result = $0 }
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should dispatch the new value")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testRemoveObservers() {
        
        userName.addObserver { _ in }
        userName.addObserver { _ in }
        userName.addObserver { _ in }
        
        userName.removeObservers()
        
        XCTAssertEqual(userName.observersCount, 0, "Should remove the observers")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testValueChangeWillDispatchTheValueToObservers() {
        
        var result = ""
        
        userName.addObserver { result = $0 }
        
        userName.value = "John"
        
        XCTAssertEqual(result, "John", "Should dispatch the new value")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testDispatchWillChangeTheValue() {
        
        let value = "Jane"
        
        userName.dispatch(value)
        
        XCTAssertEqual(userName.value, value, "Should change the value")
    }
    
    func testAtomicSetValue() {
        
        let value = "Jane"
        
        userName.value = value
        
        XCTAssertEqual(userName.value, value, "Should set the new value")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testAtomicGetValue() {
        
        let value = userName.value
        
        XCTAssertEqual(value, initialValue, "Should get the current value")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    /// MARK: ObservableValue Extensions Tests
    
    func testDispatchOnMainQueue() {
        
        let expectation = expectationWithDescription("Should dispatch on main queue")
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        observe(userName)
            .next { _ in
                
                if NSThread.isMainThread() == true {
                    expectation.fulfill()
                }
            }
            .addTo(signalContainer)
        
        dispatch_async(queue) {
            
            self.userName.dispatch("John", on: .Main)
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDispatchOnBackgroundQueue() {
        
        let expectation = expectationWithDescription("Should dispatch on background queue")
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        observe(userName)
            .next { _ in
                
                if NSThread.isMainThread() == false {
                    expectation.fulfill()
                }
            }
            .addTo(signalContainer)
        
        dispatch_async( dispatch_get_main_queue() ){
            
            self.userName.dispatch("Jack", on: .Background(queue))
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}
