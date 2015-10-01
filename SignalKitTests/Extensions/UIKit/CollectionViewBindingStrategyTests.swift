//
//  CollectionViewBindingStrategyTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 10/1/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionViewBindingStrategyTests: XCTestCase {

    var collectionView: MockCollectionView!
    var bindingStrategy: CollectionViewBindingStrategy!
    var sections: NSIndexSet!
    var paths: [NSIndexPath]!
    
    override func setUp() {
        super.setUp()
        
        collectionView = MockCollectionView()
        bindingStrategy = CollectionViewBindingStrategy(collectionView: collectionView)
        sections = NSIndexSet()
        paths = [NSIndexPath()]
    }
    
    func testReloadAllSections() {
        
        bindingStrategy.reloadAllSections()
        
        XCTAssertEqual(collectionView.isReloadDataCalled, true, "Should call the collction view to reload the data")
    }
    
    func testInsertSections() {
        
        bindingStrategy.insertSections(sections)
        
        XCTAssertEqual(collectionView.isInsertSectionsCalled, true, "Should call the collection view to insert new sections")
    }
    
    func testReloadSections() {
        
        bindingStrategy.reloadSections(sections)
        
        XCTAssertEqual(collectionView.isReloadSectionsCalled, true, "Should call the collection view to reload sections")
    }
    
    func testDeleteSections() {
        
        bindingStrategy.deleteSections(sections)
        
        XCTAssertEqual(collectionView.isDeleteSectionsCalled, true, "Should call the collection view to delete sections")
    }
    
    func testReloadRowsInSection() {
        
        bindingStrategy.reloadRowsInSections(sections)
        
        XCTAssertEqual(collectionView.isReloadSectionsCalled, true, "Should call the collection view to reload sections")
    }
    
    func testInsertRowsAtIndexPaths() {
        
        bindingStrategy.insertRowsAtIndexPaths(paths)
        
        XCTAssertEqual(collectionView.isInsertItemsCalled, true, "Should call the collection view to insert items")
    }
    
    func testReloadRowsAtIndexPaths() {
        
        bindingStrategy.reloadRowsAtIndexPaths(paths)
        
        XCTAssertEqual(collectionView.isReloadItemsCalled, true, "Should call the collection view to reload items")
    }
    
    func testDeleteRowsAtIndexPaths() {
        
        bindingStrategy.deleteRowsAtIndexPaths(paths)
        
        XCTAssertEqual(collectionView.isDeleteItemsCalled, true, "Should call the collecton view to delete items")
    }
    
    func testPerformBatchUpdate() {
        
        var called = false
        bindingStrategy.performBatchUpdate { called = true }
        
        XCTAssertEqual(called, true, "Should call the batch action")
        XCTAssertEqual(collectionView.isPerformBarchUpdatesCalled, true, "Should call the collection view to perform a batch udpates")
    }
}
