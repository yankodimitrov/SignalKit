//
//  UITableView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITableView_SignalTests: XCTestCase {

    var collection: MockObservableCollection!
    var signalsBag: DisposableBag!
    var tableView: MockTableView!
    
    override func setUp() {
        super.setUp()
        
        collection = MockObservableCollection()
        signalsBag = DisposableBag()
        tableView = MockTableView()
    }
    
    func testBindToTableView() {
        
        var changeSet = CollectionChangeSet()
        
        changeSet.insertItemsInRange(0..<2, inSection: 0)
        
        collection.observe()
            .bindTo(tableView: tableView)
            .disposeWith(signalsBag)
        
        collection.changeSetSignal.dispatch(changeSet)
        
        XCTAssertEqual(tableView.isInsertRowsCalled, true, "Should bind the collection changes to table view")
    }
}
