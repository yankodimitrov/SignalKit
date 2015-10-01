//
//  UITableView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension ArrayBindingObserver {
    
    /**
        Bind the changes in the ObservableArray to a UITableView
    
    */
    public func bindTo(tableView tableView: UITableView, dataSource: UITableViewDataSource) -> Disposable {
        
        bindingStrategy = TableViewBindingStrategy(tableView: tableView)
        
        tableView.dataSource = dataSource
        tableView.reloadData()
        
        return self
    }
}

internal final class TableViewBindingStrategy: ArrayBindingStrategyType {
    
    private weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
    }
    
    func reloadAllSections() {
        
        tableView?.reloadData()
    }
    
    func insertSections(sections: NSIndexSet) {
        
        tableView?.insertSections(sections, withRowAnimation: .Automatic)
    }
    
    func reloadSections(sections: NSIndexSet) {
        
        tableView?.reloadSections(sections, withRowAnimation: .Automatic)
    }
    
    func deleteSections(sections: NSIndexSet) {
        
        tableView?.deleteSections(sections, withRowAnimation: .Automatic)
    }
    
    func reloadRowsInSections(sections: NSIndexSet) {
        
        tableView?.reloadSections(sections, withRowAnimation: .Automatic)
    }
    
    func insertRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        tableView?.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
    }
    
    func reloadRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        tableView?.reloadRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
    }
    
    func deleteRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        tableView?.deleteRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
    }
    
    func performBatchUpdate(update: () -> Void) {
        
        tableView?.beginUpdates()
        
        update()
        
        tableView?.endUpdates()
    }
}
