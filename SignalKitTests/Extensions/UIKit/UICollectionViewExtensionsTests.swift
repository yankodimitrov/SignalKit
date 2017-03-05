//
//  UICollectionViewExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UICollectionViewExtensionsTests: XCTestCase {

    var collectionView: MockCollectionView!
    var bag: DisposableBag!
    var event: CollectionEvent!
    var signal: Signal<CollectionEvent>!
    
    override func setUp() {
        super.setUp()
        
        collectionView = MockCollectionView()
        bag = DisposableBag()
        event = CollectionEvent()
        signal = Signal<CollectionEvent>()
        
        signal.bindTo(collectionView).disposeWith(bag)
    }
    
    func testBindToTableView() {
        
        event.sectionInsertedAt(0)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isInsertSectionsCalled, "Should bind the collection change event to collection view")
    }
    
    func testObserveCollectionReset() {
        
        event.sectionsReset()
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isReloadDataCalled, "Should call the collection view to reload the data")
    }
    
    func testObserveSectionInsert() {
        
        event.sectionInsertedAt(1)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isInsertSectionsCalled, "Should call the collection view to insert section")
    }
    
    func testObserveSectionRemove() {
        
        event.sectionRemovedAt(0)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isDeleteSectionsCalled, "Should call the collection view to delete section")
    }
    
    func testObserveSectionUpdate() {
        
        event.sectionUpdatedAt(2)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isReloadSectionsCalled, "Should call the collection view to reload section")
    }
    
    func testObserveItemInsert() {
        
        event.itemInsertedAt(0, inSection: 1)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isInsertItemsCalled, "Should call the collection view to insert item")
    }
    
    func testObserveItemRemove() {
        
        event.itemRemovedAt(1, inSection: 2)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isDeleteItemsCalled, "Should call the collection view to delete item")
    }
    
    func testObserveItemUpdate() {
        
        event.itemUpdatedAt(0, inSection: 1)
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isReloadItemsCalled, "Should call the collection view to reload item")
    }
    
    func testDispose() {
        
        let disposable = MockDisposable()
        
        signal.disposableSource = disposable
        
        let binding = signal.bindTo(collectionView)
        
        binding.dispose()
        
        XCTAssertTrue(disposable.isDisposeCalled, "Should dispose the disposable source")
    }
    
    func testProcessOnlyResetOperation() {
        
        event.itemInsertedAt(0, inSection: 0)
        event.sectionRemovedAt(0)
        event.sectionsReset()
        
        signal.send(event)
        
        XCTAssertTrue(collectionView.isReloadDataCalled, "Should reload the collection view")
        XCTAssertFalse(collectionView.isInsertItemsCalled)
        XCTAssertFalse(collectionView.isInsertSectionsCalled)
    }
}
