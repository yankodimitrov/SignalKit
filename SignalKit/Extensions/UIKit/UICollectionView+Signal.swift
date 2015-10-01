//
//  UICollectionView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 10/1/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

internal final class CollectionViewBindingStrategy: ArrayBindingStrategyType {
    
    private weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        
        self.collectionView = collectionView
    }
    
    func reloadAllSections() {
        
        collectionView?.reloadData()
    }
    
    func insertSections(sections: NSIndexSet) {
        
        collectionView?.insertSections(sections)
    }
    
    func reloadSections(sections: NSIndexSet) {
        
        collectionView?.reloadSections(sections)
    }
    
    func deleteSections(sections: NSIndexSet) {
        
        collectionView?.deleteSections(sections)
    }
    
    func reloadRowsInSections(sections: NSIndexSet) {
        
        collectionView?.reloadSections(sections)
    }
    
    func insertRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        collectionView?.insertItemsAtIndexPaths(paths)
    }
    
    func reloadRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        collectionView?.reloadItemsAtIndexPaths(paths)
    }
    
    func deleteRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        collectionView?.deleteItemsAtIndexPaths(paths)
    }
    
    func performBatchUpdate(update: () -> Void) {
        
        collectionView?.performBatchUpdates(update, completion: nil)
    }
}
