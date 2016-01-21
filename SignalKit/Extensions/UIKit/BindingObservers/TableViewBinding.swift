//
//  TableViewBinding.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

internal final class TableViewBinding {
    
    internal weak var tableView: UITableView?
    internal var observer: Disposable?
    internal var rowAnimation = UITableViewRowAnimation.Automatic
    
    deinit {
        
        dispose()
    }
}

// MARK: - Disposable

extension TableViewBinding: Disposable {
    
    internal func dispose() {
        
        observer?.dispose()
        observer = nil
    }
}

// MARK: - Observe ObservableCollectionType

extension TableViewBinding {
    
    internal func observeCollection(collection: ObservableCollectionType) {
        
        observer = collection.changeSetSignal.addObserver { [weak self] in
            
            self?.handleCollectionChangeSet($0)
        }
    }
    
    private func handleCollectionChangeSet(changeSet: CollectionChangeSet) {
        
        let handler = CollectionChangeSetHandler()
        
        handler.handleChangeSet(changeSet)
        
        guard !handler.shouldResetCollection else {
            
            tableView?.reloadData()
            return
        }
        
        tableView?.beginUpdates()
        
        insertSections(handler.insertedSections)
        updateSections(handler.updatedSections)
        removeSections(handler.removedSections)
        
        insertItemsWithIndexPaths(handler.insertedIndexPaths)
        updateItemsWithIndexPaths(handler.updatedIndexPaths)
        removeItemsWithIndexPaths(handler.removedIndexPaths)
        
        tableView?.endUpdates()
    }
    
    private func insertSections(sections: Set<Int>) {
        
        guard !sections.isEmpty else { return }
        
        tableView?.insertSections(NSIndexSet(withSet: sections), withRowAnimation: rowAnimation)
    }
    
    private func updateSections(sections: Set<Int>) {
        
        guard !sections.isEmpty else { return }
        
        tableView?.reloadSections(NSIndexSet(withSet: sections), withRowAnimation: rowAnimation)
    }
    
    private func removeSections(sections: Set<Int>) {
        
        guard !sections.isEmpty else { return }
        
        tableView?.deleteSections(NSIndexSet(withSet: sections), withRowAnimation: rowAnimation)
    }
    
    private func insertItemsWithIndexPaths(paths: [NSIndexPath]) {
        
        guard !paths.isEmpty else { return }
        
        tableView?.insertRowsAtIndexPaths(paths, withRowAnimation: rowAnimation)
    }
    
    private func updateItemsWithIndexPaths(paths: [NSIndexPath]) {
        
        guard !paths.isEmpty else { return }
        
        tableView?.reloadRowsAtIndexPaths(paths, withRowAnimation: rowAnimation)
    }
    
    private func removeItemsWithIndexPaths(paths: [NSIndexPath]) {
        
        guard !paths.isEmpty else { return }
        
        tableView?.deleteRowsAtIndexPaths(paths, withRowAnimation: rowAnimation)
    }
}
