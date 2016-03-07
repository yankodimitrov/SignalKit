//
//  MockCollectionView.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

class MockCollectionView: UICollectionView {
    
    var isReloadDataCalled = false
    var isInsertSectionsCalled = false
    var isReloadSectionsCalled = false
    var isDeleteSectionsCalled = false
    var isInsertItemsCalled = false
    var isReloadItemsCalled = false
    var isDeleteItemsCalled = false
    var isPerformBarchUpdatesCalled = false
    
    convenience init() {
        
        let layout = UICollectionViewFlowLayout()
        
        self.init(frame: CGRectZero, collectionViewLayout: layout)
    }
    
    override func reloadData() {
        
        isReloadDataCalled = true
    }
    
    override func insertSections(sections: NSIndexSet) {
        
        isInsertSectionsCalled = true
    }
    
    override func reloadSections(sections: NSIndexSet) {
        
        isReloadSectionsCalled = true
    }
    
    override func deleteSections(sections: NSIndexSet) {
        
        isDeleteSectionsCalled = true
    }
    
    override func insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        
        isInsertItemsCalled = true
    }
    
    override func reloadItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        
        isReloadItemsCalled = true
    }
    
    override func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        
        isDeleteItemsCalled = true
    }
    
    override func performBatchUpdates(updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        
        updates?()
        isPerformBarchUpdatesCalled = true
    }
}
