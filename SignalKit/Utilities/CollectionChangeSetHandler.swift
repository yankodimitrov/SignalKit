//
//  CollectionChangeSetHandler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal final class CollectionChangeSetHandler {
    
    internal private(set) lazy var insertedSections = Set<Int>()
    internal private(set) lazy var updatedSections = Set<Int>()
    internal private(set) lazy var removedSections = Set<Int>()
    internal private(set) var shouldResetCollection = false
    
    internal private(set) lazy var insertedIndexPaths = [NSIndexPath]()
    internal private(set) lazy var updatedIndexPaths = [NSIndexPath]()
    internal private(set) lazy var removedIndexPaths = [NSIndexPath]()
    
    internal init() {}
}

extension CollectionChangeSetHandler {
    
    internal func handleChangeSet(var changeSet: CollectionChangeSet) {
        
        guard !changeSet.collectionOperations.contains(.Reset) else {
            
            shouldResetCollection = true
            return
        }
        
        handleSectionsChanges(changeSet)
        handleItemsChanges(changeSet)
        
        shouldResetCollection = false
    }
    
    private func handleSectionsChanges(var changeSet: CollectionChangeSet) {
        
        for operation in changeSet.collectionOperations {
            
            switch operation {
            
            case let .Insert(index): insertedSections.insert(index)
            case let .Update(index): updatedSections.insert(index)
            case let .Remove(index): removedSections.insert(index)
            default: break
            }
        }
    }
    
    private func handleItemsChanges(var changeSet: CollectionChangeSet) {
        
        for (section, operations) in changeSet.sectionsOperations {
            
            handleListOperations(operations, inSection: section)
        }
    }
    
    private func handleListOperations(operations: Set<ListOperation>, inSection: Int) {
        
        for operation in operations {
            
            switch operation {
            
            case let .Insert(index):
                insertedIndexPaths.append(NSIndexPath(forItem: index, inSection: inSection))
            
            case let .Update(index):
                updatedIndexPaths.append(NSIndexPath(forItem: index, inSection: inSection))
            
            case let .Remove(index):
                removedIndexPaths.append(NSIndexPath(forItem: index, inSection: inSection))
            
            default: break
            }
        }
    }
}
