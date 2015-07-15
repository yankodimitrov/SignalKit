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
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        let observable = ObservableOf<Int>()
        
        lock = MockLock()
        signal = Signal<Int>(observable: observable, lock: lock)
        userName = ObservableOf<String>()
        signalContainer = SignalContainer()
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
    
    func testAddToSignalContainer() {
        
        var result = ""
        
        observe(userName)
            .next{ result = $0 }
            .addTo(signalContainer)
        
        userName.dispatch("John")
        
        XCTAssertEqual(signalContainer.signalsCount, 1, "Should add the signal chain to signal container")
        XCTAssertEqual(result, "John", "Should retain the signal chain")
    }
    
    func testMap() {
        
        var result: Int = 0
        
        observe(userName)
            .map { count($0) }
            .next { result = $0 }
            .addTo(signalContainer)
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, 4, "Should transform a signal of type T to signal of type U")
    }
    
    func testFilter() {
        
        var result: Int = 0
        let number = ObservableOf<Int>()
        
        observe(number)
            .filter { $0 > 3 }
            .next { result = $0 }
            .addTo(signalContainer)
        
        number.dispatch(1)
        number.dispatch(4)
        number.dispatch(3)
        
        XCTAssertEqual(result, 4, "Should dispatch only the value that matches the filter predicate")
    }
    
    func testSkip() {
        
        var result: Int = 0
        let number = ObservableOf<Int>()
        
        number.dispatch(0)
        
        observe(number)
            .skip(2)
            .next { result = $0 }
            .addTo(signalContainer)
        
        number.dispatch(1)
        number.dispatch(4)
        number.dispatch(3)
        
        XCTAssertEqual(result, 3, "Should skip a certain number of dispatched values")
    }
    
    func testDeliverOnMain() {
        
        let expectation = expectationWithDescription("Should deliver on main queue")
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        observe(userName)
            .deliverOn(.Main)
            .next { _ in
                
                if NSThread.isMainThread() == true {
                    
                    expectation.fulfill()
                }
            }
            .addTo(signalContainer)
        
        dispatch_async(queue) {
            
            self.userName.dispatch("John")
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDeliverOnBackgroundQueue() {
        
        let expectation = expectationWithDescription("Should deliver on background queue")
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        observe(userName)
            .deliverOn(.Background(queue))
            .next { _ in
                
                if NSThread.isMainThread() == false {
                    
                    expectation.fulfill()
                }
            }
            .addTo(signalContainer)
        
        dispatch_async( dispatch_get_main_queue() ){
            
            self.userName.dispatch("John")
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testBindToObservable() {
        
        let destination = ObservableValue<String>("")
        
        observe(userName)
            .bindTo(destination)
            .addTo(signalContainer)
        
        userName.dispatch("Jack")
        
        XCTAssertEqual(destination.value, "Jack", "Should bind a signal value to observable of the same type")
    }
}
