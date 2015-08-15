//
//  ObservablePropertyTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class ObservablePropertyTests: XCTestCase {
    
    var lock: MockLock!
    var userName: ObservableProperty<String>!
    
    override func setUp() {
        super.setUp()
        
        lock = MockLock()
        userName = ObservableProperty<String>(value: "", lock: lock)
    }
    
    
    func testValueChangeWillDispatch() {
        
        var result = ""
        
        userName.addObserver { result = $0 }
        userName.value = "John"
        
        XCTAssertEqual(result, "John", "Should dispatch the value changes to observers")
    }
    
    func testValueGetter() {
        
        userName.value = "John"
        
        XCTAssertEqual(userName.value, "John", "Should return the current value")
    }
    
    func testDispatchWillUpdateTheValue() {
        
        userName.dispatch("John")
        
        XCTAssertEqual(userName.value, "John", "Dispatch should update the current value")
    }
    
    func testAtomicValueSetter() {
        
        userName.value = "John"
        
        XCTAssertEqual(lock.isLockCalled, true, "Should lock")
        XCTAssertEqual(lock.isUnlockCalled, true, "Should unlock")
        XCTAssertEqual(lock.synchronizationCounter, 0, "Should perform balanced lock/unlock")
    }
    
    func testAtomicValueGetter() {
        
        let name = userName.value
        
        XCTAssertEqual(name, "", "Should return the current value")
        XCTAssertEqual(lock.isLockCalled, true, "Should lock")
        XCTAssertEqual(lock.isUnlockCalled, true, "Should unlock")
        XCTAssertEqual(lock.synchronizationCounter, 0, "Should perform balanced lock/unlock")
    }
    
    func testObserve() {
        
        let signal = userName.observe()
        var result = ""
        
        signal.next { result = $0 }
        
        userName.dispatch("Jack")
        
        XCTAssertEqual(result, "Jack", "Should return a signal that can be used to form a chain of operations on the upcoming changes in the observable")
    }
}
