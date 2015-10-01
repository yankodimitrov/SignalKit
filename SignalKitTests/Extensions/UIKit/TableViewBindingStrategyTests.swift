//
//  TableViewBindingStrategyTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class TableViewBindingStrategyTests: XCTestCase {
    
    var tableView: MockTableView!
    var bindingStrategy: TableViewBindingStrategy!
    var sections: NSIndexSet!
    var paths: [NSIndexPath]!
    
    override func setUp() {
        super.setUp()
        
        tableView = MockTableView()
        bindingStrategy = TableViewBindingStrategy(tableView: tableView)
        
        sections = NSIndexSet()
        paths = [NSIndexPath()]
    }
    
    func testReloadAllSections() {
        
        bindingStrategy.reloadAllSections()
        
        XCTAssertEqual(tableView.isReloadDataCalled, true, "Should call the table view to reload data")
    }
    
    func testInsertSections() {
        
        bindingStrategy.insertSections(sections)
        
        XCTAssertEqual(tableView.isInsertSectionsCalled, true, "Should call the table view to insert sections")
    }
    
    func testReloadSections() {
        
        bindingStrategy.reloadSections(sections)
        
        XCTAssertEqual(tableView.isReloadSectionsCalled, true, "Should call the table view to reload sections")
    }
    
    func testReleteSections() {
        
        bindingStrategy.deleteSections(sections)
        
        XCTAssertEqual(tableView.isDeleteSectionsCalled, true, "Should call the table view to delete sections")
    }
    
    func testReloadRowsInSections() {
        
        bindingStrategy.reloadRowsInSections(sections)
        
        XCTAssertEqual(tableView.isReloadSectionsCalled, true, "Should call the table view to reload sections")
    }
    
    func testInsertRowsAtIndexPaths() {
        
        bindingStrategy.insertRowsAtIndexPaths(paths)
        
        XCTAssertEqual(tableView.isInsertRowsCalled, true, "Should call the table view to insert rows in section")
    }
    
    func testReloadRowsAtIndexPaths() {
        
        bindingStrategy.reloadRowsAtIndexPaths(paths)
        
        XCTAssertEqual(tableView.isReloadRowsCalled, true, "Should call the table view to reload rows in section")
    }
    
    func testDeleteRowsAtIndexPaths() {
        
        bindingStrategy.deleteRowsAtIndexPaths(paths)
        
        XCTAssertEqual(tableView.isDeleteRowsCalled, true, "Should call the table view to delete rows in section")
    }
    
    func testPerformBatchUpdate() {
        
        var called = false
        
        bindingStrategy.performBatchUpdate {
            called = true
        }
        
        XCTAssertEqual(called, true, "Should perform the batch update")
        XCTAssertEqual(tableView.isBeginEndUpdatesCalled, true, "Should call the table view to perform batch update")
    }
}
