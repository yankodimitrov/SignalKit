//
//  CollectionEventTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionEventTests: XCTestCase {
    
    var event: CollectionEvent!
    
    override func setUp() {
        super.setUp()
        
        event = CollectionEvent()
    }
    
    // MARK: - Element
    
    func testSectionElementEquality() {
        
        let elementA = CollectionEvent.Element.Section(0)
        let elementB = CollectionEvent.Element.Section(0)
        
        XCTAssertEqual(elementA, elementB, "Should be equal")
    }
    
    func testSectionElementInequality() {
        
        let elementA = CollectionEvent.Element.Section(0)
        let elementB = CollectionEvent.Element.Section(10)
        
        XCTAssertNotEqual(elementA, elementB, "Should be non equal")
    }
    
    func testItemElementEquality() {
        
        let elementA = CollectionEvent.Element.Item(index: 0, section: 0)
        let elementB = CollectionEvent.Element.Item(index: 0, section: 0)
        
        XCTAssertEqual(elementA, elementB, "Should be equal")
    }
    
    func testItemElementInequality() {
        
        let elementA = CollectionEvent.Element.Item(index: 0, section: 0)
        let elementB = CollectionEvent.Element.Item(index: 1, section: 2)
        
        XCTAssertNotEqual(elementA, elementB, "Should be non equal")
    }
    
    func testElementInequality() {
        
        let elementA = CollectionEvent.Element.Section(1)
        let elementB = CollectionEvent.Element.Item(index: 1, section: 2)
        
        XCTAssertNotEqual(elementA, elementB, "Should be non equal")
    }
    
    func testSectionElementHashValue() {
        
        let elementA = CollectionEvent.Element.Section(0)
        let elementB = CollectionEvent.Element.Section(0)
        
        XCTAssertEqual(elementA.hashValue, elementB.hashValue, "Should be equal")
    }
    
    func testItemElementHashValue() {
        
        let elementA = CollectionEvent.Element.Item(index: 0, section: 1)
        let elementB = CollectionEvent.Element.Item(index: 0, section: 1)
        
        XCTAssertEqual(elementA.hashValue, elementB.hashValue, "Should be equal")
    }
    
    // MARK: - Operation
    
    func testResetOperationEquality() {
        
        let operationA = CollectionEvent.Operation.Reset
        let operationB = CollectionEvent.Operation.Reset
        
        XCTAssertEqual(operationA, operationB, "Should be equal")
    }
    
    func testInsertOperationEquality() {
        
        let operationA = CollectionEvent.Operation.Insert(.Section(0))
        let operationB = CollectionEvent.Operation.Insert(.Section(0))
        
        XCTAssertEqual(operationA, operationB, "Should be equal")
    }
    
    func testRemoveOperationEquality() {
        
        let operationA = CollectionEvent.Operation.Remove(.Section(0))
        let operationB = CollectionEvent.Operation.Remove(.Section(0))
        
        XCTAssertEqual(operationA, operationB, "Should be equal")
    }
    
    func testUpdateOperationEquality() {
        
        let operationA = CollectionEvent.Operation.Update(.Section(0))
        let operationB = CollectionEvent.Operation.Update(.Section(0))
        
        XCTAssertEqual(operationA, operationB, "Should be equal")
    }
    
    func testOperationInequality() {
        
        let operationA = CollectionEvent.Operation.Reset
        let operationB = CollectionEvent.Operation.Update(.Section(0))
        
        XCTAssertNotEqual(operationA, operationB, "Should be non equal")
    }
    
    func testResetOperationHashValue() {
        
        let operationA = CollectionEvent.Operation.Reset
        let operationB = CollectionEvent.Operation.Reset
        
        XCTAssertEqual(operationA.hashValue, operationB.hashValue, "Should be equal")
    }
    
    func testInsertOperationHashValue() {
        
        let operationA = CollectionEvent.Operation.Insert(.Section(0))
        let operationB = CollectionEvent.Operation.Insert(.Section(0))
        
        XCTAssertEqual(operationA.hashValue, operationB.hashValue, "Should be equal")
    }
    
    func testRemoveOperationHashValue() {
        
        let operationA = CollectionEvent.Operation.Remove(.Section(0))
        let operationB = CollectionEvent.Operation.Remove(.Section(0))
        
        XCTAssertEqual(operationA.hashValue, operationB.hashValue, "Should be equal")
    }
    
    func testUpdateOperationHashValue() {
        
        let operationA = CollectionEvent.Operation.Update(.Section(0))
        let operationB = CollectionEvent.Operation.Update(.Section(0))
        
        XCTAssertEqual(operationA.hashValue, operationB.hashValue, "Should be equal")
    }
    
    // MARK: - CollectionEvent
    
    func testOperationsSetIsEmpty() {
        
        XCTAssertTrue(event.operations.isEmpty, "Operations set should be empty")
    }
    
    func testResetSectons() {
        
        event.sectionsReset()
        
        XCTAssertTrue(event.operations.contains(.Reset), "Should contain a reset operation")
    }
    
    func testSectionInsertedAt() {
        
        event.sectionInsertedAt(1)
        
        XCTAssertTrue(event.operations.contains(.Insert(.Section(1))), "Should contain the insert section operation")
    }
    
    func testSectionRemovedAt() {
        
        event.sectionRemovedAt(2)
        
        XCTAssertTrue(event.operations.contains(.Remove(.Section(2))), "Should contain the remove section operation")
    }
    
    func testSectionUpdatedAt() {
        
        event.sectionUpdatedAt(0)
        
        XCTAssertTrue(event.operations.contains(.Update(.Section(0))), "Should contain the update section operation")
    }
    
    func testItemInsertedAt() {
        
        event.itemInsertedAt(0, inSection: 0)
        
        XCTAssertTrue(event.operations.contains(.Insert(.Item(index: 0, section: 0))), "Should contain the insert item operation")
    }
    
    func testItemRemovedAt() {
        
        event.itemRemovedAt(0, inSection: 0)
        
        XCTAssertTrue(event.operations.contains(.Remove(.Item(index: 0, section: 0))), "Should contain the remove item operation")
    }
    
    func testItemUpdatedAt() {
        
        event.itemUpdatedAt(0, inSection: 0)
        
        XCTAssertTrue(event.operations.contains(.Update(.Item(index: 0, section: 0))), "Should contain the update item operation")
    }
    
    func testContainsResetOperation() {
        
        event.sectionsReset()
        
        XCTAssertTrue(event.containsResetOperation, "Should contain a reset operation")
    }
}
