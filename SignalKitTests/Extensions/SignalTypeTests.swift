//
//  SignalTypeTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class SignalTypeTests: XCTestCase {
    
    var signal: MockSignal<Int>!
    var chain: Disposable?
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        signal = MockSignal<Int>()
        chain = nil
        signalsBag = DisposableBag()
    }
    
    func testDispose() {
        
        let sourceSignal = MockSignal<Int>()
        let signal = DummySignal<Int>()
        
        signal.disposableSource = sourceSignal
        signal.dispose()
        
        XCTAssertEqual(sourceSignal.isDisposeCalled, true, "Should dispose the source signal")
    }
    
    func testNext() {
        
        var result = 0
        
        signal.next { result = $0 }
        
        signal.dispatch(2)
        
        XCTAssertEqual(result, 2, "Should add a new observer to the signal")
    }
    
    func testMap() {
        
        let signal = MockSignal<String>()
        var result = 0
        
        chain = signal.map { $0.characters.count }.next { result = $0 }
        
        signal.dispatch("John")
        
        XCTAssertEqual(result, 4, "Should transform a signal of type T to signal of type U")
    }
    
    func testFilter() {
        
        var result = 0
        
        chain = signal.filter { $0 > 3 }.next { result = $0 }
        
        signal.dispatch(1)
        signal.dispatch(2)
        signal.dispatch(3)
        signal.dispatch(44)
        
        XCTAssertEqual(result, 44, "Should dispatch only the value that matches the filter predicate")
    }
    
    func testSkip() {
        
        var result = 0
        
        chain = signal.skip(2).next { result = $0 }
        
        signal.dispatch(11)
        signal.dispatch(22)
        signal.dispatch(33)
        
        XCTAssertEqual(result, 33, "Should skip a certain number of dispatched values")
    }
    
    func testAddToSignalContainer() {
        
        var result = 0
        
        signal.next { result = $0 }.addTo(signalsBag)
        
        signal.dispatch(18)
        
        XCTAssertEqual(result, 18, "Should store the signal or chain of signal operations in a signal container")
    }
    
    func testDeliverOn() {
        
        let expectation = expectationWithDescription("Should deliver on a background queue")
        
        signal
            .deliverOn(.UserInitiatedQueue)
            .next { v in
                
                if !NSThread.isMainThread() {
                    
                    expectation.fulfill()
                }
            }
            .addTo(signalsBag)
        
        signal.dispatch(10)
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDebounce() {
        
        let expectation = expectationWithDescription("Should debounce the dispatch of the signal")
        let scheduler = SignalScheduler(queue: .MainQueue)
        var result = [Int]()
        
        signal
            .debounce(0.1)
            .next { result.append($0) }
            .addTo(signalsBag)
        
        signal.dispatch(1)
        signal.dispatch(2)
        signal.dispatch(3)
        
        scheduler.delay(0.1) {
            
            if result == [3] {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDelay() {
        
        let expectation = expectationWithDescription("Should delay the dispatch of the signal")
        let scheduler = SignalScheduler(queue: .MainQueue)
        var result = 0
        
        signal
            .delay(0.1)
            .next { result = $0 }
            .addTo(signalsBag)
        
        scheduler.delay(0.2) {
            
            if result == 55 {
                
                expectation.fulfill()
            }
        }
        
        signal.dispatch(55)
        
        waitForExpectationsWithTimeout(0.2, handler: nil)
    }
    
    func testCombineLatestWith() {
        
        let signalA = MockSignal<Int>()
        let signalB = MockSignal<Int>()
        
        var result = (0, 0)
        
        signalA.combineLatestWith(signalB)
            .next { result = $0 }
            .addTo(signalsBag)
        
        signalA.dispatch(4)
        signalA.dispatch(1)
        
        signalB.dispatch(11)
        
        XCTAssertEqual(result.0, 1, "Should contain the latest value from signalA")
        XCTAssertEqual(result.1, 11, "Should contain the latest value from signalB")
    }
    
    func testCombineTwoLatestSignals() {
        
        let signalA = MockSignal<Int>()
        let signalB = MockSignal<Int>()
        
        var result = (0, 0)
        
        combineLatest(signalA, signalB)
            .next { result = $0 }
            .addTo(signalsBag)
        
        signalA.dispatch(1)
        signalA.dispatch(2)
        
        signalB.dispatch(11)
        signalB.dispatch(22)
        signalB.dispatch(33)
        
        XCTAssertEqual(result.0, 2, "Should contain the latest value from signalA")
        XCTAssertEqual(result.1, 33, "Should contain the latest value from signalB")
    }
    
    func testCombineThreeLatestSignals() {
        
        let signalA = MockSignal<Int>()
        let signalB = MockSignal<Int>()
        let signalC = MockSignal<Int>()
        
        var result = (0, 0, 0)
        
        combineLatest(signalA, signalB, signalC)
            .next { result = $0 }
            .addTo(signalsBag)
        
        signalA.dispatch(1)
        signalA.dispatch(2)
        
        signalB.dispatch(11)
        
        signalC.dispatch(111)
        signalC.dispatch(222)
        
        XCTAssertEqual(result.0, 2, "Should contain the latest value from signalA")
        XCTAssertEqual(result.1, 11, "Should contain the latest value from signalB")
        XCTAssertEqual(result.2, 222, "Should contain the latest value from signalC")
    }
    
    func testAllForTupleWithTwoBooleans() {
        
        let correct = [false, false, false, true]
        var result = [Bool]()
        
        let signal = MockSignal<(Bool, Bool)>()
        
        signal
            .all { $0 == true }
            .next { result.append($0) }
            .addTo(signalsBag)
        
        signal.dispatch((false, false))
        signal.dispatch((false, true))
        signal.dispatch((true, false))
        signal.dispatch((true, true))
        
        XCTAssertEqual(result, correct, "Should dispatch true only when all values are equal to true")
    }
    
    func testSomeForTupleWithTwoBooleans() {
        
        let correct = [false, true, true, true]
        var result = [Bool]()
        
        let signal = MockSignal<(Bool, Bool)>()
        
        signal
            .some { $0 == true }
            .next { result.append($0) }
            .addTo(signalsBag)
        
        signal.dispatch((false, false))
        signal.dispatch((false, true))
        signal.dispatch((true, false))
        signal.dispatch((true, true))
        
        XCTAssertEqual(result, correct, "Should dispatch true when some of the values are equal to true")
    }
    
    func testAllForTupleWithThreeBooleans() {
        
        let correct = [false, false, false, true]
        var result = [Bool]()
        
        let signal = MockSignal<(Bool, Bool, Bool)>()
        
        signal
            .all { $0 == true }
            .next { result.append($0) }
            .addTo(signalsBag)
        
        signal.dispatch((false, false, false))
        signal.dispatch((true, false, false))
        signal.dispatch((false, true, false))
        signal.dispatch((true, true, true))
        
        XCTAssertEqual(result, correct, "Should dispatch true only when all values are equal to true")
    }
    
    func testSomeForTupleWithThreeBooleans() {
        
        let correct = [false, true, true, true]
        var result = [Bool]()
        
        let signal = MockSignal<(Bool, Bool, Bool)>()
        
        signal
            .some { $0 == true }
            .next { result.append($0) }
            .addTo(signalsBag)
        
        signal.dispatch((false, false, false))
        signal.dispatch((true, false, false))
        signal.dispatch((false, true, false))
        signal.dispatch((true, true, true))
        
        XCTAssertEqual(result, correct, "Should dispatch true when some of the values are equal to true")
    }
    
    func testDistinct() {
        
        let signal = MockSignal<Int>()
        let correct = [2, 55, 2]
        var result = [Int]()
        
        signal.dispatch(2)
        
        signal
            .distinct()
            .next { result.append($0) }
            .addTo(signalsBag)
        
        signal.dispatch(2)
        signal.dispatch(2)
        signal.dispatch(55)
        signal.dispatch(2)
        signal.dispatch(2)
        
        XCTAssertEqual(result, correct, "Should dispatch new value only if it is not equal to the previous one.")
    }
    
    func testBindToObservable() {
        
        let observable = MockObservable<Int>()
        let signal = MockSignal<Int>()
        let correct = [400, 401]
        var result = [Int]()
        
        signal.dispatch(400)
        
        signal
            .bindTo(observable)
            .addTo(signalsBag)
        
        observable.addObserver {
            result.append($0)
        }
        
        signal.dispatch(401)
        
        XCTAssertEqual(result, correct, "Should bind the signal value to an Observable of the same type")
    }
}
