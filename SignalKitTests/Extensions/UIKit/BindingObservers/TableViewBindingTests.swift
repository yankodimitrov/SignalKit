//
//  TableViewBindingTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class TableViewBindingTests: XCTestCase {

    var binding: TableViewBinding!
    var collection: MockObservableCollection!
    var tableView: MockTableView!
    
    override func setUp() {
        super.setUp()
        
        binding = TableViewBinding()
        collection = MockObservableCollection()
        tableView = MockTableView()
        
        binding.tableView = tableView
        binding.observeCollection(collection)
    }
    
    func testDisposeBindingObserver() {
        
        let fakeDisposable = MockDisposable()
        
        binding.observer = fakeDisposable
        
        binding.dispose()
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose the binding")
        XCTAssert(binding.observer == nil, "Should set the disposable observer to nil")
    }
    
    func testDisposeOnDeinit() {
        
        let fakeDisposable = MockDisposable()
        
        var bindingObserver: TableViewBinding? = TableViewBinding()
        
        bindingObserver?.observer = fakeDisposable
        
        bindingObserver = nil
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose on deinit")
    }
    
    func testObserveCollectionReset() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.replaceAllSections()
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isReloadDataCalled, true, "Should reload data in table view")
    }
    
    func testObserveCollectionInsertSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertSectionAtIndex(0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isInsertSectionsCalled, true, "Should call the table view to insert sections")
    }
    
    func testObserveCollectionUpdateSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.updateSectionAtIndex(1)
        changeSet.updateSectionAtIndex(2)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isReloadSectionsCalled, true, "Should call the table view to reload sections")
    }
    
    func testObserveCollectionRemoveSection() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.removeSectionAtIndex(0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isDeleteSectionsCalled, true, "Should call the table view to delete sections")
    }
    
    func testObserveCollectionInsertItem() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertItemAtIndex(0, inSection: 1)
        changeSet.insertItemAtIndex(1, inSection: 2)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isInsertRowsCalled, true, "Should call the table view to insert rows")
    }
    
    func testObserveCollectionUpdateItem() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.updateItemAtIndex(2, inSection: 0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isReloadRowsCalled, true, "Should call the table view to reload rows")
    }
    
    func testObserveCollectionRemoveItem() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.removeItemAtIndex(0, inSection: 0)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isDeleteRowsCalled, true, "Should call the table view to delete rows")
    }
}
