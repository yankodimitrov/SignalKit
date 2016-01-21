//
//  CollectionViewBindingObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class CollectionViewBindingObserverTests: XCTestCase {
    
    var bindingObserver: CollectionViewBindingObserver!
    var collection: MockObservableCollection!
    var collectionView: MockCollectionView!
    
    override func setUp() {
        super.setUp()
        
        bindingObserver = CollectionViewBindingObserver()
        collection = MockObservableCollection()
        collectionView = MockCollectionView()
        
        bindingObserver.collectionView = collectionView
        bindingObserver.observeCollection(collection)
    }
    
    func testDisposeBindingObserver() {
        
        let fakeDisposable = MockDisposable()
        
        bindingObserver.observer = fakeDisposable
        
        bindingObserver.dispose()
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose the binding")
        XCTAssert(bindingObserver.observer == nil, "Should set the disposable observer to nil")
    }
    
    func testDisposeOnDeinit() {
        
        let fakeDisposable = MockDisposable()
        
        var bindingObserver: CollectionViewBindingObserver? = CollectionViewBindingObserver()
        
        bindingObserver?.observer = fakeDisposable
        
        bindingObserver = nil
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose on deinit")
    }
    
    func testObserveCollectionReset() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceAllSections()
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isReloadDataCalled, true, "Should reload data in collection view")
    }
    
    func testObserveCollectionInsertSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertSectionAtIndex(0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isInsertSectionsCalled, true, "Should call the collection view to insert sections")
    }
    
    func testObserveCollectionUpdateSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.updateSectionAtIndex(1)
        changeSet.updateSectionAtIndex(2)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isReloadSectionsCalled, true, "Should call the collection view to reload sections")
    }
    
    func testObserveCollectionRemoveSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.removeSectionAtIndex(0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isDeleteSectionsCalled, true, "Should call the collection view to delete sections")
    }
    
    func testObserveCollectionInsertItem() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertItemAtIndex(0, inSection: 1)
        changeSet.insertItemAtIndex(1, inSection: 2)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isInsertItemsCalled, true, "Should call the collection view to insert rows")
    }
    
    func testObserveCollectionUpdateItem() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.updateItemAtIndex(2, inSection: 0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isReloadItemsCalled, true, "Should call the collection view to reload rows")
    }
    
    func testObserveCollectionRemoveItem() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.removeItemAtIndex(0, inSection: 0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(collectionView.isDeleteItemsCalled, true, "Should call the collection view to delete rows")
    }
}
