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
}
