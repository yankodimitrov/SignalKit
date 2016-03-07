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
    
    func testIsSection() {
        
        let element = CollectionEvent.Element.Section(10)
        
        XCTAssertTrue(element.isSection, "Should return true")
    }
    
    func testIsNotASection() {
        
        let element = CollectionEvent.Element.Item(index: 0, section: 10)
        
        XCTAssertFalse(element.isSection, "Should return false")
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
    
    func testResetIsNotSectionOperation() {
        
        let operation = CollectionEvent.Operation.Reset
        
        XCTAssertFalse(operation.isSectionOperation, "Should return false")
    }
    
    func testInsertIsNotSectionOperation() {
        
        let operation = CollectionEvent.Operation.Insert(.Item(index: 0, section: 0))
        
        XCTAssertFalse(operation.isSectionOperation, "Should return false")
    }
    
    func testRemoveIsNotSectionOperation() {
        
        let operation = CollectionEvent.Operation.Remove(.Item(index: 0, section: 0))
        
        XCTAssertFalse(operation.isSectionOperation, "Should return false")
    }
    
    func testUpdateIsNotSectionOperation() {
        
        let operation = CollectionEvent.Operation.Update(.Item(index: 0, section: 0))
        
        XCTAssertFalse(operation.isSectionOperation, "Should return false")
    }
    
    func testInsertIsSectionOperation() {
        
        let operation = CollectionEvent.Operation.Insert(.Section(0))
        
        XCTAssertTrue(operation.isSectionOperation, "Should return true")
    }
    
    func testRemoveIsSectionOperation() {
        
        let operation = CollectionEvent.Operation.Remove(.Section(1))
        
        XCTAssertTrue(operation.isSectionOperation, "Should return true")
    }
    
    func testUpdateIsSectionOperation() {
        
        let operation = CollectionEvent.Operation.Update(.Section(2))
        
        XCTAssertTrue(operation.isSectionOperation, "Should return true")
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
