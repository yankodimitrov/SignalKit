//
//  CollectionChangeSetHandlerTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionChangeSetHandlerTests: XCTestCase {

    func testHandleChangeSetWithSectionChanges() {
        
        let handler = CollectionChangeSetHandler()
        var changeSet = CollectionChangeSet()
        
        changeSet.insertSectionAtIndex(0)
        changeSet.updateSectionAtIndex(1)
        changeSet.removeSectionAtIndex(2)
        
        handler.handleChangeSet(changeSet)
        
        XCTAssertEqual(handler.insertedSections, Set([0]), "Should contain the inserted")
        XCTAssertEqual(handler.updatedSections, Set([1]), "Should contain the updated")
        XCTAssertEqual(handler.removedSections, Set([2]), "Should contain the remvoed")
        XCTAssertEqual(handler.shouldResetCollection, false, "Should be equal to false")
    }
    
    func testHandleChangeSetCollectionReset() {
        
        let handler = CollectionChangeSetHandler()
        var changeSet = CollectionChangeSet()
        
        changeSet.insertSectionAtIndex(0)
        changeSet.replaceAllSections()
        
        handler.handleChangeSet(changeSet)
        
        XCTAssertEqual(handler.shouldResetCollection, true, "Should reset the collection")
    }
    
    func testHandlerChangeSetWithItemsChanges() {
        
        let handler = CollectionChangeSetHandler()
        var changeSet = CollectionChangeSet()
        
        let expectedInsertedItems = [NSIndexPath(forItem: 0, inSection: 0)]
        let expectedUpdatedItems = [NSIndexPath(forItem: 1, inSection: 0)]
        let expectedRemovedItems = [NSIndexPath(forItem: 0, inSection: 2)]
        
        changeSet.insertItemAtIndex(0, inSection: 0)
        changeSet.updateItemAtIndex(1, inSection: 0)
        changeSet.removeItemAtIndex(0, inSection: 2)
        
        handler.handleChangeSet(changeSet)
        
        XCTAssertEqual(handler.insertedIndexPaths, expectedInsertedItems, "Should contain the inserted items")
        XCTAssertEqual(handler.updatedIndexPaths, expectedUpdatedItems, "Should contain the updated items")
        XCTAssertEqual(handler.removedIndexPaths, expectedRemovedItems, "Should contain the removed itesm")
        XCTAssertEqual(handler.shouldResetCollection, false, "Should be equal to false")
    }
}
