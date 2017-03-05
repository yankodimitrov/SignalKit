//
//  SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class SignalTests: XCTestCase {
    
    var chain: Disposable?
    
    func testCreateAtomicSignal() {
        
        let name = Signal<String>.atomic()
        
        XCTAssertTrue(name.lock is MutexLock)
    }
    
    func testLockAddObserver() {
        
        let lock = MockLock()
        let name = Signal<String>(lock: lock)
        
        _ = name.addObserver { _ in }
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testLockSendValue() {
        
        let lock = MockLock()
        let name = Signal<String>(lock: lock)
        
        name.send("Atomic")
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testLockRemoveObserverWithToken() {
        
        let lock = MockLock()
        let name = Signal<String>(lock: lock)
        
        let observer = name.addObserver { _ in }
        
        observer.dispose()
        
        XCTAssertTrue(lock.lockCalled)
        XCTAssertTrue(lock.unlockCalled)
    }
    
    func testAddObserver() {
        
        let name = Signal<String>()
        
        name.addObserver { _ in }
        
        XCTAssertEqual(name.observers.items.count, 1, "Should add a new observer")
    }
    
    func testDisposeObserver() {
        
        let name = Signal<String>()
        var result = ""
        
        let observer = name.addObserver { result = $0 }
        
        observer.dispose()
        
        name.send("John")
        
        XCTAssertEqual(name.observers.items.isEmpty, true, "Should remove the observer")
        XCTAssertEqual(result, "", "Should contain an empty string")
    }
    
    func testsendValueToObserver() {
        
        let name = Signal<String>()
        var result = ""
        let expectedResult = "John"

        name.addObserver { result = $0 }
        name.send(expectedResult)
        
        XCTAssertEqual(result, expectedResult, "Should send the next value to observers")
    }
    
    func testNext() {
        
        let name = Signal<String>()
        var result = ""
        let expectedResult = "John"
        
        _ = name.next { result = $0 }
        name.send(expectedResult)
        
        XCTAssertEqual(result, expectedResult, "Should add a new observer to a Signal")
    }
    
    func testMap() {
        
        let year = Signal<Int>()
        var result = ""
        let expectedResult = "2016"
        
        chain = year.map { String($0) }.next { result = $0 }
        
        year.send(2016)
        
        XCTAssertEqual(result, expectedResult, "Should map the signal value")
    }
    
    func testFilter() {
        
        let number = Signal<Int>()
        var result = 0
        
        chain = number.filter { $0 > 5 }.next { result = $0 }
        
        number.send(1)
        number.send(2)
        number.send(7)
        number.send(5)
        
        XCTAssertEqual(result, 7, "Should filter the signal values")
    }
    
    func testSkip() {
        
        let number = Signal<Int>()
        var result = 0
        
        chain = number.skip(2).next { result = $0 }
        
        number.send(1)
        number.send(2)
        number.send(3)
        number.send(4)
        
        XCTAssertEqual(result, 4, "Should skip a number of sent values")
    }
    
    
    func testObserveOnQueue() {
        
        let expectation = self.expectation(description: "Should deliver the value on the main queue")
        let signal = Signal<Int>()
        let scheduler = Scheduler(queue: .backgroundQueue)
        
        chain = signal.observeOn(.mainQueue).next { _ in
            
            if Thread.isMainThread {
                
                expectation.fulfill()
            }
        }
        
        scheduler.async {
            
            signal.send(111)
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testsendOnQueue() {
        
        let expectation = self.expectation(description: "Should send next value on a given queue")
        let signal = Signal<Int>()
        let scheduler = Scheduler(queue: .backgroundQueue)
        
        chain = signal.next { _ in
            
            if Thread.isMainThread {
                
                expectation.fulfill()
            }
        }
        
        scheduler.async {
            
            signal.send(1, onQueue: .mainQueue)
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDebounce() {
        
        let expectation = self.expectation(description: "Should debounce the sent values")
        let scheduler = Scheduler(queue: .mainQueue)
        let signal = Signal<Int>()
        var result = [Int]()
        
        chain = signal.debounce(0.1).next { result.append($0) }
        
        signal.send(1)
        signal.send(2)
        signal.send(3)
        
        scheduler.delay(0.1) {
            
            if result == [3] {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDelay() {
        
        let expectation = self.expectation(description: "Should delay the sent values")
        let scheduler = Scheduler(queue: .mainQueue)
        let signal = Signal<Int>()
        var result = 0
        
        chain = signal.delay(0.1).next { result = $0 }
        
        scheduler.delay(0.2) {
            
            if result == 11 {
                
                expectation.fulfill()
            }
        }
        
        signal.send(11)
        
        waitForExpectations(timeout: 0.2, handler: nil)
    }
    
    func testBindTo() {
        
        let signalA = Signal<Int>()
        let signalB = Signal<Int>()
        var result = 0
        
        chain = signalA.bindTo(signalB)
        
        signalB.addObserver { result = $0 }
        
        signalA.send(3)
        
        XCTAssertEqual(result, 3, "Should bind a signal to a signal of the same type")
    }
    
    func testDistinct() {
        
        let signal = Signal<Int>()
        var result = [Int]()
        let expectedResult = [2, 33, 2]
        
        chain = signal.distinct().next { result.append($0) }
        
        signal.send(2)
        signal.send(2)
        signal.send(2)
        signal.send(33)
        signal.send(2)
        
        XCTAssertEqual(result, expectedResult, "Should send only distinct values")
    }
    
    func testCombineLatestWith() {
        
        let signalA = Signal<Int>()
        let signalB = Signal<String>()
        var result = (0, "")
        
        chain = signalA.combineLatestWith(signalB).next { result = $0 }
        
        signalA.send(1)
        signalA.send(11)
        signalB.send("foo")
        signalA.send(4)
        signalB.send("bar")
        
        XCTAssertEqual(result.0, 4, "Should contain the latest value of signal A")
        XCTAssertEqual(result.1, "bar", "Should contain the latest value of signal B")
    }
    
    func testAllEqual() {
        
        let signal = Signal<(Bool, Bool)>()
        var result = [Bool]()
        let expectedResult = [false, false, false, true]
        
        chain = signal.allEqual { $0 == true }.next { result.append($0) }
        
        signal.send((false, false))
        signal.send((false, true))
        signal.send((true, false))
        signal.send((true, true))
        
        XCTAssertEqual(result, expectedResult, "Should send true if all values are matching the predicate")
    }
    
    func testSomeEqual() {
        
        let signal = Signal<(Bool, Bool)>()
        var result = [Bool]()
        let expectedResult = [false, true, true, true]
        
        chain = signal.someEqual { $0 == true }.next { result.append($0) }
        
        signal.send((false, false))
        signal.send((false, true))
        signal.send((true, false))
        signal.send((true, true))
        
        XCTAssertEqual(result, expectedResult, "Should send true if some of the values match the predicate")
    }
    
    func testDisposeWith() {
        
        let bag = DisposableBag()
        let signal = Signal<Int>()
        var result = 0
        
        signal.next { result = $0 }.disposeWith(bag)
        
        signal.send(1)
        
        XCTAssertEqual(result, 1, "Should store the chain of operations")
        XCTAssertEqual(bag.disposables.items.count, 1, "Should contain one item")
    }
}
