//
//  MockTableView.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 10/1/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

class MockTableView: UITableView {
    
    var isReloadDataCalled = false
    var isInsertSectionsCalled = false
    var isReloadSectionsCalled = false
    var isDeleteSectionsCalled = false
    
    var isInsertRowsCalled = false
    var isReloadRowsCalled = false
    var isDeleteRowsCalled = false
    
    var isBeginUpdatesCalled = false
    var isEndUpdatesCalled = false
    
    var isBeginEndUpdatesCalled: Bool {
        
        return isBeginUpdatesCalled == true && isEndUpdatesCalled == true
    }
    
    override func reloadData() {
        
        isReloadDataCalled = true
    }
    
    override func insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        
        isInsertSectionsCalled = true
    }
    
    override func reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        
        isReloadSectionsCalled = true
    }
    
    override func deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        
        isDeleteSectionsCalled = true
    }
    
    override func beginUpdates() {
        
        isBeginUpdatesCalled = true
    }
    
    override func endUpdates() {
        
        isEndUpdatesCalled = true
    }
    
    override func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        
        isInsertRowsCalled = true
    }
    
    override func reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        
        isReloadRowsCalled = true
    }
    
    override func deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        
        isDeleteRowsCalled = true
    }
}
