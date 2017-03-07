//
//  SignalPropertyTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class SignalPropertyTests: XCTestCase {
    
    func testInitializeAtomic() {
        
        let name = SignalProperty<String>(value: "", atomic: true)
        
        XCTAssertTrue(name.signal.lock is MutexLock)
    }
    
    func testInitializeNonAtomic() {
        
        let name = SignalProperty<String>(value: "", atomic: false)
        
        XCTAssertNil(name.signal.lock)
    }
    
    func testLockValueSetter() {
        
        let lock = MockLock()
        let name = SignalProperty<String>(value: "", lock: lock)
        
        name.value = "John"
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testLockValueGetter() {
        
        let lock = MockLock()
        let name = SignalProperty<String>(value: "", lock: lock)
        
        _ = name.value
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testLockAddObserver() {
        
        let lock = MockLock()
        let name = SignalProperty<String>(value: "", lock: lock)
        
        _ = name.addObserver { _ in }
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testLockSendValue() {
        
        let lock = MockLock()
        let name = SignalProperty<String>(value: "", lock: lock)
        
        name.send("Atomic")
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testLockRemoveObserverWithToken() {
        
        let lock = MockLock()
        let name = SignalProperty<String>(value: "", lock: lock)
        
        let observer = name.addObserver { _ in }
        
        observer.dispose()
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testInitWithValue() {
        
        let signal = SignalProperty(value: "John")
        
        XCTAssertEqual(signal.value, "John", "Should init with value")
    }
    
    func testSendValueWhenChanged() {
        
        let signal = SignalProperty(value: 1)
        var result = 0
        
        signal.addObserver { result = $0 }
        signal.value = 8
        
        XCTAssertEqual(result, 8, "Should send the value on value change")
    }
    
    func testSendCurrentValueWhenNewObserverIsAdded() {
        
        let signal = SignalProperty(value: "John")
        var result = ""
        
        _ = signal.next { result = $0 }
        
        XCTAssertEqual(result, "John", "Should send the current value to new observers")
    }
    
    func testSendNext() {
        
        let signal = SignalProperty(value: 2)
        var result = 0
        
        _ = signal.next { result = $0 }
        _ = signal.send(3)
        
        XCTAssertEqual(result, 3, "Should send the new value")
        XCTAssertEqual(signal.value, 3, "Should change the current value")
    }
}
