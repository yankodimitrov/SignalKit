//
//  SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class SignalTests: XCTestCase {
    
    var signal: Signal<Int>!
    var lock: MockLock!
    var userName: ObservableOf<String>!
    
    override func setUp() {
        super.setUp()
        
        let observable = ObservableOf<Int>()
        
        lock = MockLock()
        signal = Signal<Int>(observable: observable, lock: lock)
        userName = ObservableOf<String>()
    }
    
    func testAddObserver() {
        
        signal.addObserver { _ in }
        
        XCTAssertEqual(signal.observersCount, 1, "Should add observer")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testRemoveObserver() {
        
        let observer = signal.addObserver { _ in }
        
        lock.lockCalled = false
        lock.unlockCalled = false
        
        observer.dispose()
        
        XCTAssertEqual(signal.observersCount, 0, "Should remove the observer")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testDispatch() {
        
        var result = 0
        
        signal.addObserver { result = $0 }
        
        signal.dispatch(2)
        
        XCTAssertEqual(result, 2, "Should dispatch the new value")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testRemoveObservers() {
        
        signal.addObserver { _ in }
        signal.addObserver { _ in }
        signal.addObserver { _ in }
        
        signal.removeObservers()
        
        XCTAssertEqual(signal.observersCount, 0, "Should remove the observers")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testAddDisposableItem() {
        
        let item = MockDisposable()
        
        signal.addDisposable(item)
        
        XCTAssertEqual(signal.disposablesCount, 1, "Should add disposable item")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testDispose() {
        
        let item = MockDisposable()
        
        signal.addDisposable(item)
        
        signal.dispose()
        
        XCTAssertEqual(item.disposed, true, "Should call dispose on each disposable item")
        XCTAssertEqual(signal.observersCount, 0, "Should remove all observers")
        XCTAssertEqual(signal.disposablesCount, 0, "Should remove all disposables")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testDisposeSignalSource() {
        
        let sourceSignal = MockSignal()
        
        signal.sourceSignal = sourceSignal
        
        signal.dispose()
        
        XCTAssertEqual(sourceSignal.disposed, true, "Should call the signal source to dispose")
    }
    
    /// MARK: Signal Extensions Tests
    
    func testNext() {
        
        var result = ""
        
        let signal = observe(userName).next { result = $0 }
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should add a new observer to the signal")
    }
}
