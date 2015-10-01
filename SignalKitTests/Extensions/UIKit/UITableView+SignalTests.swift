//
//  UITableView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 10/1/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UITableView_SignalTests: XCTestCase {
    
    var list: ObservableArray<Int>!
    var tableView: MockTableView!
    var signalsBag: DisposableBag!
    var dataSource: MockTableViewDataSource!
    
    override func setUp() {
        super.setUp()
        
        list = ObservableArray([1, 2, 3])
        tableView = MockTableView()
        signalsBag = DisposableBag()
        dataSource = MockTableViewDataSource()
    }
    
    func testBindToTableView() {
        
        list.observe()
            .bindTo(tableView: tableView, dataSource: dataSource)
            .addTo(signalsBag)
        
        list.append(4)
        
        XCTAssertEqual(tableView.isInsertRowsCalled, true, "Should bind the changes in observable array to table view")
        XCTAssertEqual(tableView.isReloadDataCalled, true, "Should call the table view to reload data")
        XCTAssert(tableView.dataSource === dataSource, "Should set the table view data source")
    }
}
