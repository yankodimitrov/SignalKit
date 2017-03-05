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
    var animation = UITableViewRowAnimation.automatic
    
    var isBeginEndUpdatesCalled: Bool {
        
        return isBeginUpdatesCalled == true && isEndUpdatesCalled == true
    }
    
    override func reloadData() {
        
        isReloadDataCalled = true
    }
    
    override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        
        isInsertSectionsCalled = true
        self.animation = animation
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        
        isReloadSectionsCalled = true
        self.animation = animation
    }
    
    override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        
        isDeleteSectionsCalled = true
        self.animation = animation
    }
    
    override func beginUpdates() {
        
        isBeginUpdatesCalled = true
    }
    
    override func endUpdates() {
        
        isEndUpdatesCalled = true
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        
        isInsertRowsCalled = true
        self.animation = animation
    }
    
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        
        isReloadRowsCalled = true
        self.animation = animation
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        
        isDeleteRowsCalled = true
        self.animation = animation
    }
}
