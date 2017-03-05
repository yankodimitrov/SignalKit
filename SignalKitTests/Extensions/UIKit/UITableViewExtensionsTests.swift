//
//  UITableViewExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITableViewExtensionsTests: XCTestCase {

    var tableView: MockTableView!
    var bag: DisposableBag!
    var event: CollectionEvent!
    var signal: Signal<CollectionEvent>!
    
    override func setUp() {
        super.setUp()
        
        tableView = MockTableView()
        bag = DisposableBag()
        event = CollectionEvent()
        signal = Signal<CollectionEvent>()
        
        signal.bindTo(tableView, rowAnimation: .fade).disposeWith(bag)
    }
    
    func testBindToTableView() {
        
        event.sectionInsertedAt(0)
        
        signal.send(event)
        
        XCTAssert(tableView.animation == .fade, "Should set the row animaton")
        XCTAssertTrue(tableView.isInsertSectionsCalled, "Should bind the collection change event to table view")
        XCTAssertTrue(tableView.isBeginUpdatesCalled, "Should call table view to begin updates")
        XCTAssertTrue(tableView.isEndUpdatesCalled, "Should call the table view to end updates")
    }
    
    func testObserveCollectionReset() {
        
        event.sectionsReset()
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isReloadDataCalled, "Should call the table view to reload the data")
    }
    
    func testObserveSectionInsert() {
        
        event.sectionInsertedAt(1)
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isInsertSectionsCalled, "Should call the table view to insert section")
    }
    
    func testObserveSectionRemove() {
        
        event.sectionRemovedAt(0)
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isDeleteSectionsCalled, "Should call the table view to delete section")
    }
    
    func testObserveSectionUpdate() {
        
        event.sectionUpdatedAt(2)
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isReloadSectionsCalled, "Should call the table view to reload section")
    }
    
    func testObserveRowInsert() {
        
        event.itemInsertedAt(0, inSection: 1)
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isInsertRowsCalled, "Should call the table view to insert row")
    }
    
    func testObserveRowRemove() {
        
        event.itemRemovedAt(1, inSection: 2)
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isDeleteRowsCalled, "Should call the table view to delete row")
    }
    
    func testObserveRowUpdate() {
        
        event.itemUpdatedAt(0, inSection: 1)
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isReloadRowsCalled, "Should call the table view to reload row")
    }
    
    func testDispose() {
        
        let disposable = MockDisposable()
        
        signal.disposableSource = disposable
        
        let binding = signal.bindTo(tableView)
        
        binding.dispose()
        
        XCTAssertTrue(disposable.isDisposeCalled, "Should dispose the disposable source")
    }
    
    func testProcessOnlyResetOperation() {
        
        event.itemInsertedAt(0, inSection: 0)
        event.sectionRemovedAt(0)
        event.sectionsReset()
        
        signal.send(event)
        
        XCTAssertTrue(tableView.isReloadDataCalled, "Should reload the table view")
        XCTAssertFalse(tableView.isInsertRowsCalled)
        XCTAssertFalse(tableView.isInsertSectionsCalled)
    }
}
