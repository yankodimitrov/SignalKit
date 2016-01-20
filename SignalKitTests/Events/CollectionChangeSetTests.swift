//
//  CollectionChangeSetTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionChangeSetTests: XCTestCase {

    func testReplaceAllSections() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceAllSections()
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testInsertSectionAtIndex() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertSectionAtIndex(1)
        
        let operations = changeSet.collectionOperations
        let sectionOperations = changeSet.sectionsOperations[1]
        
        XCTAssertEqual(operations.contains(.Insert(index: 1)), true, "Should contain the insert operation")
        XCTAssertEqual(sectionOperations?.isEmpty, true, "Should insert a new section")
    }
    
    func testInsertSectionAtIndexReturnsIfThereIsResetOperation() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceAllSections()
        changeSet.insertSectionAtIndex(0)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.contains(.Reset), true, "Should return if there is a reset operation in the collection")
        XCTAssertEqual(operations.count, 1, "Should contain only one operations")
    }
    
    func testReplaceAllSectionsRemovesAllPreviousOperations() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertSectionAtIndex(1)
        changeSet.insertSectionAtIndex(2)
        changeSet.replaceAllSections()
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testUpdateSectionAtIndex() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.updateSectionAtIndex(2)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Update(index: 2)), true, "Should contain the update operation")
    }
    
    func testUpdateSectionAtIndexReturnsIfThereIsResetOperation() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceAllSections()
        changeSet.updateSectionAtIndex(2)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testRemoveSectionAtIndex() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.removeSectionAtIndex(2)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Remove(index: 2)), true, "Should contain the remove operation")
    }
    
    func testRemoveSectionAtIndexReturnsIfThereIsResetOperation() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceAllSections()
        changeSet.removeSectionAtIndex(22)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testReplaceItemsInSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceItemsInSection(0)
        
        let operations = changeSet.sectionsOperations
        
        XCTAssert(operations[0] != nil, "Should insert a new set at index 0")
        XCTAssertEqual(operations[0]?.contains(.Reset), true, "Should contain the reset operation")
    }
}
