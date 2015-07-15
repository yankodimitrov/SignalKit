//
//  FunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class FunctionsTests: XCTestCase {

    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        signalContainer = SignalContainer()
    }
    
    /// MARK: - Observe Observable
    
    func testObserveObservable() {
        
        let name = ObservableOf<String>()
        var result = ""
        
        let signal = observe(name) {
            result = $0
        }
        
        name.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should observe an observable")
    }
    
    func testObserveObservableWithoutCallback() {
        
        let name = ObservableOf<String>()
        
        let signal = observe(name)
        
        XCTAssertEqual(name.observersCount, 1, "Should observe an observable even without a callback")
    }
    
    func testObserveObservableWillDispose() {
        
        let name = ObservableOf<String>()
        var result = ""
        
        let signal = observe(name) {
            result = $0
        }
        
        signal.dispose()
        
        name.dispatch("John")
        
        XCTAssertEqual(result, "", "Should dispose the observation")
    }
}
