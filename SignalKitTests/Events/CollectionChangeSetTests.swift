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

    var changeSet: CollectionChangeSet!
    
    override func setUp() {
        super.setUp()
        
        changeSet = CollectionChangeSet()
    }
    
    func testReplaceAllSections() {
        
        changeSet.replaceAllSections()
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testInsertSectionAtIndex() {
        
        changeSet.insertSectionAtIndex(1)
        
        let operations = changeSet.collectionOperations
        let sectionOperations = changeSet.sectionsOperations[1]
        
        XCTAssertEqual(operations.contains(.Insert(index: 1)), true, "Should contain the insert operation")
        XCTAssertEqual(sectionOperations?.isEmpty, true, "Should insert a new section")
    }
    
    func testInsertSectionAtIndexReturnsIfThereIsResetOperation() {
        
        changeSet.replaceAllSections()
        changeSet.insertSectionAtIndex(0)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.contains(.Reset), true, "Should return if there is a reset operation in the collection")
        XCTAssertEqual(operations.count, 1, "Should contain only one operations")
    }
    
    func testReplaceAllSectionsRemovesAllPreviousOperations() {
        
        changeSet.insertSectionAtIndex(1)
        changeSet.insertSectionAtIndex(2)
        changeSet.replaceAllSections()
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testUpdateSectionAtIndex() {
        
        changeSet.updateSectionAtIndex(2)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Update(index: 2)), true, "Should contain the update operation")
    }
    
    func testUpdateSectionAtIndexReturnsIfThereIsResetOperation() {
        
        changeSet.replaceAllSections()
        changeSet.updateSectionAtIndex(2)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testRemoveSectionAtIndex() {
        
        changeSet.removeSectionAtIndex(2)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Remove(index: 2)), true, "Should contain the remove operation")
    }
    
    func testRemoveSectionAtIndexReturnsIfThereIsResetOperation() {
        
        changeSet.replaceAllSections()
        changeSet.removeSectionAtIndex(22)
        
        let operations = changeSet.collectionOperations
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testReplaceItemsInSection() {
        
        changeSet.replaceItemsInSection(0)
        
        let operations = changeSet.operationsSetForSection(0)
        
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
    
    func testInsertItemAtIndexInSection() {
        
        changeSet.insertItemAtIndex(10, inSection: 1)
        
        let operations = changeSet.operationsSetForSection(1)
        
        XCTAssertEqual(operations.contains(.Insert(index: 10)), true, "Should contain the insert operation")
    }
    
    func testInsertItemAtIndexWillReturnIfThereIsResetOperation() {
        
        changeSet.replaceItemsInSection(0)
        changeSet.insertItemAtIndex(2, inSection: 0)
        
        let operations = changeSet.operationsSetForSection(0)

        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain reset operation")
    }
    
    func testUpdateItemAtIndexInSection() {
        
        changeSet.updateItemAtIndex(10, inSection: 1)
        
        let operations = changeSet.operationsSetForSection(1)
        
        XCTAssertEqual(operations.contains(.Update(index: 10)), true, "Should contain the update operation")
    }
    
    func testUpdateItemAtIndexWillReturnIfThereIsResetOperation() {
        
        changeSet.replaceItemsInSection(0)
        changeSet.updateItemAtIndex(0, inSection: 0)
        
        let operations = changeSet.operationsSetForSection(0)
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain reset operation")
    }
    
    func testRemoveItemAtIndexInSection() {
        
        changeSet.removeItemAtIndex(55, inSection: 1)
        
        let operations = changeSet.operationsSetForSection(1)
        
        XCTAssertEqual(operations.contains(.Remove(index: 55)), true, "Should contain the remove operation")
    }
    
    func testRemoveItemAtIndexWillReturnIfThereIsResetOperation() {
        
        changeSet.replaceItemsInSection(0)
        changeSet.removeItemAtIndex(0, inSection: 0)
        
        let operations = changeSet.operationsSetForSection(0)
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain reset operation")
    }
    
    func testInsertMultipleItemsAtIndex() {
        
        let expectedIndexes = Set([5, 6, 7, 8])
        var indexes = Set<Int>()
        
        changeSet.insertItemsInRange(5..<9, inSection: 0)
        
        let operations = changeSet.operationsSetForSection(0)
        
        for operation in operations {
            
            if case let .Insert(index) = operation {
                
                indexes.insert(index)
            }
        }
        
        XCTAssertEqual(indexes, expectedIndexes, "Should contain the inserted indexes")
    }
    
    func testInsertMultipleItemsAtIndexWillReturnIfThereIsResetOperation() {
        
        changeSet.replaceItemsInSection(1)
        changeSet.insertItemsInRange(0..<2, inSection: 1)
        
        let operations = changeSet.operationsSetForSection(1)
        
        XCTAssertEqual(operations.count, 1, "Should contain only one operation")
        XCTAssertEqual(operations.contains(.Reset), true, "Should contain the reset operation")
    }
}
