//
//  UITableViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where ObservationValue == CollectionEvent {
    
    /// Bind the collection change events to a table view
    
    public func bindTo(tableView: UITableView, rowAnimation: UITableViewRowAnimation = .Automatic) -> Disposable {
        
        let binding = TableViewBinding()
        
        addObserver { [weak binding] in
            
            binding?.handleCollectionEvent($0)
        }
        
        binding.tableView = tableView
        binding.rowAnimation = rowAnimation
        binding.disposableSource = self
        
        return binding
    }
}

// MARK: - TableViewBinding

final class TableViewBinding: Disposable {
    
    weak var tableView: UITableView?
    var rowAnimation = UITableViewRowAnimation.Automatic
    var disposableSource: Disposable?
    
    init() {}
    
    func dispose() {
        
        disposableSource?.dispose()
    }
    
    func handleCollectionEvent(event: CollectionEvent) {
        
        guard !event.containsResetOperation else {
            
            tableView?.reloadData()
            
            return
        }
        
        tableView?.beginUpdates()
        
        handleOperations(event.operations)
        
        tableView?.endUpdates()
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
            
            tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: rowAnimation)
        }
        
        if case .Item(let section, let row) = element {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            tableView?.insertRowsAtIndexPaths([path], withRowAnimation: rowAnimation)
        }
    }
    
    func handleRemoveOperationForElement(element: CollectionEvent.Element) {
        
        if case .Section(let index) = element {
            
            tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: rowAnimation)
        }
        
        if case .Item(let section, let row) = element {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            tableView?.deleteRowsAtIndexPaths([path], withRowAnimation: rowAnimation)
        }
    }
    
    func handleUpdateOperationForElement(element: CollectionEvent.Element) {
        
        if case .Section(let index) = element {
            
            tableView?.reloadSections(NSIndexSet(index: index), withRowAnimation: rowAnimation)
        }
        
        if case .Item(let section, let row) = element {
            
            let path = NSIndexPath(forRow: row, inSection: section)
            
            tableView?.reloadRowsAtIndexPaths([path], withRowAnimation: rowAnimation)
        }
    }
}
