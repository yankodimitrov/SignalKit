//
//  UITableView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: ObservableCollectionType {
    
    /**
        Bind the changes in ObservableCollectionType to UITableView
     
    */
    public func bindTo(tableView tableView: UITableView, rowAnimation: UITableViewRowAnimation = .Automatic) -> Disposable {
        
        let binding = TableViewBinding()
        
        binding.tableView = tableView
        binding.rowAnimation = rowAnimation
        
        binding.observeCollection(sender)
        
        return binding
    }
}
