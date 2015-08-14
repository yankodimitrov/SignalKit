//
//  CompoundObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/14/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class CompoundObserverTests: XCTestCase {
    
    var signalA: MockObservable<Int>!
    var signalB: MockObservable<String>!
    var observer: Disposable!
    
    override func setUp() {
        super.setUp()
        
        signalA = MockObservable<Int>()
        signalB = MockObservable<String>()
        observer = nil
    }
    
    func testObserve() {
        
        var result = (0, "")
        
        observer = CompoundObserver(observableA: signalA, observableB: signalB) {
            
            result = $0
        }
        
        signalA.dispatch(1)
        signalB.dispatch("a")
        
        XCTAssert(result.0 == 1, "Should contain the first value")
        XCTAssert(result.1 == "a", "Should contain the second value")
    }
    
    func testObserveLatest() {
        
        signalA.dispatch(7)
        signalB.dispatch("a")
        
        var result = (0, "")
        
        observer = CompoundObserver(observableA: signalA, observableB: signalB) {
            
            result = $0
        }
        
        signalA.dispatch(8)
        signalB.dispatch("b")
        signalB.dispatch("c")
        
        XCTAssert(result.0 == 8, "Should contain the signalA latest value")
        XCTAssert(result.1 == "c", "Should contain the signalB latest value")
    }
    
    func testObserveBoth() {
        
        var result = (0, "")
        
        observer = CompoundObserver(observableA: signalA, observableB: signalB) {
            
            result = $0
        }
        
        signalB.dispatch("a")
        signalB.dispatch("b")

        XCTAssert(result.0 == 0 && result.1 == "", "Should call the callback only when both signals have send their latest values")
    }
    
    func testDispose() {
     
        var result = (0, "")
        
        observer = CompoundObserver(observableA: signalA, observableB: signalB) {
            
            result = $0
        }
        
        observer.dispose()
        
        signalA.dispatch(1)
        signalB.dispatch("a")
        
        
        XCTAssert(result.0 == 0 && result.1 == "", "Should dispose the observation")
    }
}
