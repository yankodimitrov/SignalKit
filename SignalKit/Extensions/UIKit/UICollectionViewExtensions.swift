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
    
    public func bindTo(_ collectionVIew: UICollectionView) -> Disposable {
        
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
    
    func handleCollectionEvent(_ event: CollectionEvent) {
        
        guard !event.containsResetOperation else {
            
            collectionView?.reloadData()
            
            return
        }
        
        collectionView?.performBatchUpdates({ [weak self] in
            
            self?.handleOperations(event.operations)
            
        }, completion: nil)
    }
    
    func handleOperations(_ operations: Set<CollectionEvent.Operation>) {
        
        for operation in operations {
            
            handleOperation(operation)
        }
    }
    
    func handleOperation(_ operation: CollectionEvent.Operation) {
        
        switch operation {
            
        case let .insert(element):
            
            handleInsertOperationForElement(element)
            
        case let .remove(element):
            
            handleRemoveOperationForElement(element)
            
        case let .update(element):
            
            handleUpdateOperationForElement(element)
            
        default:
            return
        }
    }
    
    func handleInsertOperationForElement(_ element: CollectionEvent.Element) {
        
        if case .section(let index) = element {
            
            collectionView?.insertSections(IndexSet(integer: index))
        }
        
        if case .item(let section, let row) = element {
            
            let path = IndexPath(row: row, section: section)
            
            collectionView?.insertItems(at: [path])
        }
    }
    
    func handleRemoveOperationForElement(_ element: CollectionEvent.Element) {
        
        if case .section(let index) = element {
            
            collectionView?.deleteSections(IndexSet(integer: index))
        }
        
        if case .item(let section, let row) = element {
            
            let path = IndexPath(row: row, section: section)
            
            collectionView?.deleteItems(at: [path])
        }
    }
    
    func handleUpdateOperationForElement(_ element: CollectionEvent.Element) {
        
        if case .section(let index) = element {
            
            collectionView?.reloadSections(IndexSet(integer: index))
        }
        
        if case .item(let section, let row) = element {
            
            let path = IndexPath(row: row, section: section)
            
            collectionView?.reloadItems(at: [path])
        }
    }
}
