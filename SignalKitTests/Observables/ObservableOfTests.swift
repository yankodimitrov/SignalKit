//
//  ObservableOfTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class ObservableOfTests: XCTestCase {

    var observable: ObservableOf<Int>!
    
    override func setUp() {
        super.setUp()
        
        observable = ObservableOf<Int>()
    }
    
    func testAddObserver() {
        
        observable.addObserver { _ in }
        
        XCTAssertEqual(observable.observersCount, 1, "Should add observer")
    }
    
    func testAddMultipleObservers() {
        
        observable.addObserver { _ in }
        observable.addObserver { _ in }
        observable.addObserver { _ in }
        
        XCTAssertEqual(observable.observersCount, 3, "Should be able to add multiple observers")
    }
    
    func testRemoveObserver() {
        
        let observer = observable.addObserver { _ in }
        
        observer.dispose()
        
        XCTAssertEqual(observable.observersCount, 0, "Should remove the observer")
    }
    
    func testDispatchNewValue() {
        
        var result = 0
        
        observable.addObserver { result = $0 }
        
        observable.dispatch(2)
        
        XCTAssertEqual(result, 2, "Should dispatch the new value to observers")
    }
    
    func testRemoveObservers() {
        
        observable.addObserver { _ in }
        observable.addObserver { _ in }
        
        observable.removeObservers()
        
        XCTAssertEqual(observable.observersCount, 0, "Should remove all observers")
    }
    
    func testNewObserverWillReceiveTheLatestValue() {
        
        var result = 0
        
        observable.dispatch(2)
        observable.addObserver { result = $0 }
        
        XCTAssertEqual(result, 2, "The default dispatch rule should dispatch the latest value to the newly added observer")
    }
    
    func testCustomDispatchRule() {
        
        // dispatch rule that never sends the latest value to the newly added observer
        
        var result = 0
        let observable = ObservableOf<Int>(dispatchRule: { _ in { return nil } })
        
        observable.dispatch(2)
        observable.addObserver { result = $0 }
        
        XCTAssertEqual(result, 0, "Should not dispatch the latest value to the newly added observer")
    }
}
