//
//  UICollectionViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where ObservationValue == CollectionEvent {
    
    /// Bind the collection change events to a collection view
    
    public func bindTo(collectionVIew: UICollectionView) -> Disposable {
        
        let binding = CollectionViewBinding()
        
        addObserver { [weak binding] in
            
            binding?.handleCollectionEvent($0)
        }
        
        binding.collectionView = collectionVIew
        binding.disposableSource = self
        
        return binding
    }
}

// MARK: - CollectionViewBinding

final class CollectionViewBinding: Disposable {
    
    weak var collectionView: UICollectionView?
    var disposableSource: Disposable?
    
    init() {}
    
    func dispose() {
        
        disposableSource?.dispose()
    }
    
    func handleCollectionEvent(event: CollectionEvent) {
        
        guard !event.containsResetOperation else {
            
            collectionView?.reloadData()
            
            return
        }
        
        collectionView?.performBatchUpdates({ [weak self] in
            
            self?.handleOperations(event.operations)
            
        }, completion: nil)
    }
    
    func handleOperations(operations: Set<CollectionEvent.Operation>) {
        
        for operation in operations {
            
            handleOperation(operation)
        }
    }
    
    func handleOperation(operation: CollectionEvent.Operation) {
        
        switch operation {
            
        case let .Insert(element):
            
            handleInsertOperationForElement(element)
            
        case let .Remove(element):
            
            handleRemoveOperationForElement(element)
            
        case let .Update(element):
            
            handleUpdateOperationForElement(element)
            
        default:
            return
        }
    }
    
    func handleInsertOperationForElement(element: CollectionEvent.Element) {
        
        if case .Section(let index) = element {
            
            collectionView?.insertSections(NSIndexSet(index: index))
        }
        
        if case .Item(let section, let row) = element {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            collectionView?.insertItemsAtIndexPaths([path])
        }
    }
    
    func handleRemoveOperationForElement(element: CollectionEvent.Element) {
        
        if case .Section(let index) = element {
            
            collectionView?.deleteSections(NSIndexSet(index: index))
        }
        
        if case .Item(let section, let row) = element {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            collectionView?.deleteItemsAtIndexPaths([path])
        }
    }
    
    func handleUpdateOperationForElement(element: CollectionEvent.Element) {
        
        if case .Section(let index) = element {
            
            collectionView?.reloadSections(NSIndexSet(index: index))
        }
        
        if case .Item(let section, let row) = element {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            collectionView?.reloadItemsAtIndexPaths([path])
        }
    }
}
