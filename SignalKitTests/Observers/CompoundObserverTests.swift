//
//  CompoundObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class CompoundObserverTests: XCTestCase {

    var signalA: ObservableOf<Int>!
    var signalB: ObservableOf<String>!
    
    override func setUp() {
        super.setUp()
        
        signalA = ObservableOf<Int>()
        signalB = ObservableOf<String>()
    }
    
    func testObserve() {
        
        var result = (0, "")
        
        let observer = CompoundObserver(signalA: signalA, signalB: signalB) {
            value in
            
            result = value
        }
        
        signalA.dispatch(2)
        signalB.dispatch("John")
        
        XCTAssertEqual(result.0, 2, "Should contain the first signal latest value")
        XCTAssertEqual(result.1, "John", "Should contain the second signal latest value")
    }
    
    func testObserveLatestValues() {
        
        var result = (0, "")
        
        signalA.dispatch(27)
        signalA.dispatch(45)
        signalB.dispatch("Jane")
        
        let observer = CompoundObserver(signalA: signalA, signalB: signalB) {
            value in
            
            result = value
        }
        
        signalA.dispatch(2)
        signalB.dispatch("John")
        
        XCTAssertEqual(result.0, 2, "Should contain the latest value from the first signal")
        XCTAssertEqual(result.1, "John", "Should contain the latest value from the second signal")
    }
    
    func testObserveBothLatestValues() {
        
        var result = (0, "")
        
        let observer = CompoundObserver(signalA: signalA, signalB: signalB) {
            value in
            
            result = value
        }
        
        signalB.dispatch("Jane")
        signalB.dispatch("John")
        
        XCTAssert(result.0 == 0 && result.1 == "", "Should call the callback only when both signals have send their latest values")
    }
    
    func testDispose() {
        
        var result = (0, "")
        
        let observer = CompoundObserver(signalA: signalA, signalB: signalB) {
            value in
            
            result = value
        }
        
        observer.dispose()
        
        signalA.dispatch(2)
        signalB.dispatch("John")
        
        XCTAssert(result.0 == 0 && result.1 == "", "Should remove observations upon disposal")
    }
}
