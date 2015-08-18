//
//  DispatcherTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class DispatcherTests: XCTestCase {
    
    var dispatcher: Dispatcher<Int>!
    
    override func setUp() {
        super.setUp()
        
        dispatcher = Dispatcher<Int>()
    }
    
    func testAddObserver() {
        
        dispatcher.addObserver { v in }
        
        XCTAssertEqual(dispatcher.observersCount, 1, "Should add observer")
    }
    
    func testAddMultipleObservers() {
        
        dispatcher.addObserver { v in }
        dispatcher.addObserver { v in }
        dispatcher.addObserver { v in }
        
        XCTAssertEqual(dispatcher.observersCount, 3, "Should add multiple observers")
    }
    
    func testDispatch() {
        
        var result = 0
        
        dispatcher.addObserver { result = $0 }
        dispatcher.dispatch(22)
        
        XCTAssertEqual(result, 22, "Should dispatch the new item to observers")
    }
    
    func testDispatchToMultipleObservers() {
        
        var resultOne = 0
        var resultTwo = 0
        
        dispatcher.addObserver { resultOne = $0 }
        dispatcher.addObserver { resultTwo = $0 }
        
        dispatcher.dispatch(21)
        
        XCTAssertEqual(resultOne, 21, "Should dispatch to all observers")
        XCTAssertEqual(resultTwo, 21, "Should dispatch to all observers")
    }
    
    func testDisposeObserver() {
        
        var result = 0
        
        let disposable = dispatcher.addObserver { result = $0 }
        
        disposable.dispose()
        
        dispatcher.dispatch(12)
        
        XCTAssertEqual(dispatcher.observersCount, 0, "Should remove the observer from observers")
        XCTAssertEqual(result, 0, "Should remove the observer on dispose")
    }
    
    func testRemoveObservers() {
        
        dispatcher.addObserver { v in }
        dispatcher.addObserver { v in }
        dispatcher.addObserver { v in }
        
        dispatcher.removeObservers()
        
        XCTAssertEqual(dispatcher.observersCount, 0, "Should remove all observers")
    }
    
    func testimmediateDispatchRule() {
        
        dispatcher.dispatch(4)
        
        var result = 0
        
        dispatcher.addObserver { result = $0 }
        
        XCTAssertEqual(result, 4, "Should dispatch immediately the latest item to newly added observers")
    }
    
    func testCustomDispatchRule() {
        
        let dispatcher = Dispatcher<Int>(dispatchRule: { v in { return nil }})
        
        dispatcher.dispatch(7)
        
        var result = 0
        
        dispatcher.addObserver { result = $0 }
        
        XCTAssertEqual(result, 0, "The custom dispatch rule should not store the latest values for upcoming observers")
    }
    
    func testAtomicAddObserver() {
        
        let lock = MockLock()
        let dispatcher = Dispatcher<Int>(lock: lock)
        
        dispatcher.addObserver { v in }
        
        XCTAssertEqual(lock.isLockCalled, true, "Should lock")
        XCTAssertEqual(lock.isUnlockCalled, true, "Should unlock")
        XCTAssertEqual(lock.synchronizationCounter, 0, "Should perform balanced lock/unlock calls")
    }
    
    func testAtomicDisposeObserver() {
        
        let lock = MockLock()
        let dispatcher = Dispatcher<Int>(lock: lock)
        
        let disposable = dispatcher.addObserver { v in }
        
        disposable.dispose()
        
        XCTAssertEqual(lock.isLockCalled, true, "Should lock")
        XCTAssertEqual(lock.isUnlockCalled, true, "Should unlock")
        XCTAssertEqual(lock.synchronizationCounter, 0, "Should perform balanced lock/unlock calls")
    }
    
    func testAtomicDispatch() {
        
        let lock = MockLock()
        let dispatcher = Dispatcher<Int>(lock: lock)
        
        dispatcher.dispatch(123)
        
        XCTAssertEqual(lock.isLockCalled, true, "Should lock")
        XCTAssertEqual(lock.isUnlockCalled, true, "Should unlock")
        XCTAssertEqual(lock.synchronizationCounter, 0, "Should perform balanced lock/unlock calls")
    }
    
    func testAtmoicRemoveObservers() {
        
        let lock = MockLock()
        let dispatcher = Dispatcher<Int>(lock: lock)
        
        dispatcher.removeObservers()
        
        XCTAssertEqual(lock.isLockCalled, true, "Should lock")
        XCTAssertEqual(lock.isUnlockCalled, true, "Should unlock")
        XCTAssertEqual(lock.synchronizationCounter, 0, "Should perform balanced lock/unlock calls")
    }
}
