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
    
    override func setUp() {
        super.setUp()
        
        lock = MockLock()
        userName = ObservableValue<String>(value: initialValue, lock: lock)
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
}
