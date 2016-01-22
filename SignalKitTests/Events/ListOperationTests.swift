//
//  ListOperationTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class ListOperationTests: XCTestCase {

    func testTwoResetOperationsAreEqual() {
        
        let a = ListOperation.Reset
        let b = ListOperation.Reset
        
        XCTAssertEqual(a == b, true, "Should be equal")
    }
    
    func testResetOperationIsNotEqualToInsertOperation() {
        
        let a = ListOperation.Reset
        let b = ListOperation.Insert(index: 1)
        
        XCTAssertEqual(a == b, false, "Should not be equal")
    }
    
    func testTwoInsertOperationsAreEqual() {
        
        let a = ListOperation.Insert(index: 1)
        let b = ListOperation.Insert(index: 1)
        
        XCTAssertEqual(a == b, true, "Should be equal")
    }
    
    func testTwoInsertOperationsAreNotEqual() {
        
        let a = ListOperation.Insert(index: 0)
        let b = ListOperation.Insert(index: 1)
        
        XCTAssertEqual(a == b, false, "Should not be equal")
    }
    
    func testTwoUpdateOperationsAreEqual() {
        
        let a = ListOperation.Update(index: 0)
        let b = ListOperation.Update(index: 0)
        
        XCTAssertEqual(a == b, true, "Should be equal")
    }
    
    func testTwoUpdateOperationsAreNotEqual() {
        
        let a = ListOperation.Update(index: 0)
        let b = ListOperation.Update(index: 12)
        
        XCTAssertEqual(a == b, false, "Should not be equal")
    }
    
    func testTwoRemoveOperationsAreEqual() {
        
        let a = ListOperation.Remove(index: 1)
        let b = ListOperation.Remove(index: 1)
        
        XCTAssertEqual(a == b, true, "Should be equal")
    }
    
    func testTwoRemoveOperationsAreNotEqual() {
        
        let a = ListOperation.Remove(index: 99)
        let b = ListOperation.Remove(index: 44)
        
        XCTAssertEqual(a == b, false, "Should not be equal")
    }
    
    func testTwoResetOperationsHaveSameHashValue() {
        
        let a = ListOperation.Reset
        let b = ListOperation.Reset
        
        XCTAssertEqual(a.hashValue == b.hashValue, true, "Should be equal")
    }
    
    func testTwoInsertOperationsHaveSameHashValue() {
        
        let a = ListOperation.Insert(index: 1)
        let b = ListOperation.Insert(index: 1)
        
        XCTAssertEqual(a.hashValue == b.hashValue, true, "Should be equal")
    }
    
    func testTwoInsertOperationsHaveDifferentHashValues() {
        
        let a = ListOperation.Insert(index: 22)
        let b = ListOperation.Insert(index: 1)
        
        XCTAssertEqual(a.hashValue == b.hashValue, false, "Should not be equal")
    }
    
    func testTwoUpdateOperationsHaveSameHashValue() {
        
        let a = ListOperation.Update(index: 1)
        let b = ListOperation.Update(index: 1)
        
        XCTAssertEqual(a.hashValue == b.hashValue, true, "Should be equal")
    }
    
    func testTwoUpdateOperationsHaveDifferentHashValues() {
        
        let a = ListOperation.Update(index: 33)
        let b = ListOperation.Update(index: 77)
        
        XCTAssertEqual(a.hashValue == b.hashValue, false, "Should not be equal")
    }
    
    func testTwoRemoveOperationsHaveSameHashValue() {
        
        let a = ListOperation.Remove(index: 0)
        let b = ListOperation.Remove(index: 0)
        
        XCTAssertEqual(a.hashValue == b.hashValue, true, "Should be equal")
    }
    
    func testTwoRemoveOperationsHaveDifferentHashValues() {
        
        let a = ListOperation.Remove(index: 33)
        let b = ListOperation.Remove(index: 11)
        
        XCTAssertEqual(a.hashValue == b.hashValue, false, "Should not be equal")
    }
    
    func testTwoDifferentOperationsHaveDifferentHashValues() {
        
        let a = ListOperation.Reset
        let b = ListOperation.Insert(index: 0)
        
        XCTAssertEqual(a.hashValue == b.hashValue, false, "Should not be equal")
    }
    
    func testTwoDifferentOperationsWithSameIndexHaveDifferentHashValues() {
        
        let a = ListOperation.Insert(index: 0)
        let b = ListOperation.Remove(index: 0)
        
        XCTAssertEqual(a.hashValue == b.hashValue, false, "Should not be equal")
    }
}
