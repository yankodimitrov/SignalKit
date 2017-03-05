//
//  UITableViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/7/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where Value == CollectionEvent {
    
    /// Bind the collection change events to a table view
    
    public func bindTo(_ tableView: UITableView, rowAnimation: UITableViewRowAnimation = .automatic) -> Disposable {
        
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
    var rowAnimation = UITableViewRowAnimation.automatic
    var disposableSource: Disposable?
    
    init() {}
    
    func dispose() {
        
        disposableSource?.dispose()
    }
    
    func handleCollectionEvent(_ event: CollectionEvent) {
        
        guard !event.containsResetOperation else {
            
            tableView?.reloadData()
            
            return
        }
        
        tableView?.beginUpdates()
        
        handleOperations(event.operations)
        
        tableView?.endUpdates()
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
            
            tableView?.insertSections(IndexSet(integer: index), with: rowAnimation)
        }
        
        if case .item(let section, let row) = element {
            
            let path = IndexPath(row: row, section: section)
            
            tableView?.insertRows(at: [path], with: rowAnimation)
        }
    }
    
    func handleRemoveOperationForElement(_ element: CollectionEvent.Element) {
        
        if case .section(let index) = element {
            
            tableView?.deleteSections(IndexSet(integer: index), with: rowAnimation)
        }
        
        if case .item(let section, let row) = element {
            
            let path = IndexPath(row: row, section: section)
            
            tableView?.deleteRows(at: [path], with: rowAnimation)
        }
    }
    
    func handleUpdateOperationForElement(_ element: CollectionEvent.Element) {
        
        if case .section(let index) = element {
            
            tableView?.reloadSections(IndexSet(integer: index), with: rowAnimation)
        }
        
        if case .item(let section, let row) = element {
            
            let path = IndexPath(row: row, section: section)
            
            tableView?.reloadRows(at: [path], with: rowAnimation)
        }
    }
}
