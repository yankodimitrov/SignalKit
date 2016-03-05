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
        
        name.sendNext("John")
        
        XCTAssertEqual(name.observers.items.isEmpty, true, "Should remove the observer")
        XCTAssertEqual(result, "", "Should contain an empty string")
    }
    
    func testSendNextValueToObserver() {
        
        let name = Signal<String>()
        var result = ""
        let expectedResult = "John"

        name.addObserver { result = $0 }
        name.sendNext(expectedResult)
        
        XCTAssertEqual(result, expectedResult, "Should send the next value to observers")
    }
    
    func testNext() {
        
        let name = Signal<String>()
        var result = ""
        let expectedResult = "John"
        
        name.next { result = $0 }
        name.sendNext(expectedResult)
        
        XCTAssertEqual(result, expectedResult, "Should add a new observer to a Signal")
    }
    
    func testMap() {
        
        let year = Signal<Int>()
        var result = ""
        let expectedResult = "2016"
        
        chain = year.map { String($0) }.next { result = $0 }
        
        year.sendNext(2016)
        
        XCTAssertEqual(result, expectedResult, "Should map the signal value")
    }
    
    func testFilter() {
        
        let number = Signal<Int>()
        var result = 0
        
        chain = number.filter { $0 > 5 }.next { result = $0 }
        
        number.sendNext(1)
        number.sendNext(2)
        number.sendNext(7)
        number.sendNext(5)
        
        XCTAssertEqual(result, 7, "Should filter the signal values")
    }
    
    func testSkip() {
        
        let number = Signal<Int>()
        var result = 0
        
        chain = number.skip(2).next { result = $0 }
        
        number.sendNext(1)
        number.sendNext(2)
        number.sendNext(3)
        number.sendNext(4)
        
        XCTAssertEqual(result, 4, "Should skip a number of sent values")
    }
    
    
    func testObserveOnQueue() {
        
        let expectation = expectationWithDescription("Should deliver the value on the main queue")
        let signal = Signal<Int>()
        let scheduler = Scheduler(queue: .BackgroundQueue)
        
        chain = signal.observeOn(.MainQueue).next { _ in
            
            if NSThread.isMainThread() {
                
                expectation.fulfill()
            }
        }
        
        scheduler.async {
            
            signal.sendNext(111)
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testSendNextOnQueue() {
        
        let expectation = expectationWithDescription("Should send next value on a given queue")
        let signal = Signal<Int>()
        let scheduler = Scheduler(queue: .BackgroundQueue)
        
        chain = signal.next { _ in
            
            if NSThread.isMainThread() {
                
                expectation.fulfill()
            }
        }
        
        scheduler.async {
            
            signal.sendNext(1, onQueue: .MainQueue)
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDebounce() {
        
        let expectation = expectationWithDescription("Should debounce the sent values")
        let scheduler = Scheduler(queue: .MainQueue)
        let signal = Signal<Int>()
        var result = [Int]()
        
        chain = signal.debounce(0.1).next { result.append($0) }
        
        signal.sendNext(1)
        signal.sendNext(2)
        signal.sendNext(3)
        
        scheduler.delay(0.1) {
            
            if result == [3] {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
