//
//  CollectionViewBinding.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

internal final class CollectionViewBinding {
    
    internal weak var collectionView: UICollectionView?
    internal var observer: Disposable?
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension CollectionViewBinding: Disposable {
    
    internal func dispose() {
        
        observer?.dispose()
        observer = nil
    }
}

// MARK: - Observe ObservableCollectionType

extension CollectionViewBinding {
    
    internal func observeCollection(collection: ObservableCollectionType) {
        
        observer = collection.changeSetSignal.addObserver { [weak self] in
            
            self?.handleCollectionChangeSet($0)
        }
    }
    
    private func handleCollectionChangeSet(changeSet: CollectionChangeSet) {
        
        let handler = CollectionChangeSetHandler()
        
        handler.handleChangeSet(changeSet)
        
        guard !handler.shouldResetCollection else {
            
            collectionView?.reloadData()
            return
        }
        
        collectionView?.performBatchUpdates({ [weak self] in
        
            self?.insertSections(handler.insertedSections)
            self?.updateSections(handler.updatedSections)
            self?.removeSections(handler.removedSections)
            
            self?.insertItemsWithIndexPaths(handler.insertedIndexPaths)
            self?.updateItemsWithIndexPaths(handler.updatedIndexPaths)
            self?.removeItemsWithIndexPaths(handler.removedIndexPaths)
            
        }, completion: nil)
    }
    
    private func insertSections(sections: Set<Int>) {
        
        guard !sections.isEmpty else { return }
        
        collectionView?.insertSections(NSIndexSet(withSet: sections))
    }
    
    private func updateSections(sections: Set<Int>) {
        
        guard !sections.isEmpty else { return }
        
        collectionView?.reloadSections(NSIndexSet(withSet: sections))
    }
    
    private func removeSections(sections: Set<Int>) {
        
        guard !sections.isEmpty else { return }
        
        collectionView?.deleteSections(NSIndexSet(withSet: sections))
    }
    
    private func insertItemsWithIndexPaths(paths: [NSIndexPath]) {
        
        guard !paths.isEmpty else { return }
        
        collectionView?.insertItemsAtIndexPaths(paths)
    }
    
    private func updateItemsWithIndexPaths(paths: [NSIndexPath]) {
        
        guard !paths.isEmpty else { return }
        
        collectionView?.reloadItemsAtIndexPaths(paths)
    }
    
    private func removeItemsWithIndexPaths(paths: [NSIndexPath]) {
        
        guard !paths.isEmpty else { return }
        
        collectionView?.deleteItemsAtIndexPaths(paths)
    }
}
