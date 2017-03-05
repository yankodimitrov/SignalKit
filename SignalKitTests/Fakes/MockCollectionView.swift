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
        
        self.init(frame: CGRect.zero, collectionViewLayout: layout)
    }
    
    override func reloadData() {
        
        isReloadDataCalled = true
    }
    
    override func insertSections(_ sections: IndexSet) {
        
        isInsertSectionsCalled = true
    }
    
    override func reloadSections(_ sections: IndexSet) {
        
        isReloadSectionsCalled = true
    }
    
    override func deleteSections(_ sections: IndexSet) {
        
        isDeleteSectionsCalled = true
    }
    
    override func insertItems(at indexPaths: [IndexPath]) {
        
        isInsertItemsCalled = true
    }
    
    override func reloadItems(at indexPaths: [IndexPath]) {
        
        isReloadItemsCalled = true
    }
    
    override func deleteItems(at indexPaths: [IndexPath]) {
        
        isDeleteItemsCalled = true
    }
    
    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        
        updates?()
        isPerformBarchUpdatesCalled = true
    }
}
