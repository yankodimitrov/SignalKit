//
//  MockTableView.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
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
    var animation = UITableViewRowAnimation.Automatic
    
    var isBeginEndUpdatesCalled: Bool {
        
        return isBeginUpdatesCalled == true && isEndUpdatesCalled == true
    }
    
    override func reloadData() {
        
        isReloadDataCalled = true
    }
    
    override func insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        
        isInsertSectionsCalled = true
        self.animation = animation
    }
    
    override func reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        
        isReloadSectionsCalled = true
        self.animation = animation
    }
    
    override func deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        
        isDeleteSectionsCalled = true
        self.animation = animation
    }
    
    override func beginUpdates() {
        
        isBeginUpdatesCalled = true
    }
    
    override func endUpdates() {
        
        isEndUpdatesCalled = true
    }
    
    override func insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        
        isInsertRowsCalled = true
        self.animation = animation
    }
    
    override func reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        
        isReloadRowsCalled = true
        self.animation = animation
    }
    
    override func deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        
        isDeleteRowsCalled = true
        self.animation = animation
    }
}
