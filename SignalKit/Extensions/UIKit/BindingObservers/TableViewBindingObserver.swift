//
//  TableViewBindingObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

internal final class TableViewBindingObserver {
    
    internal weak var tableView: UITableView?
    private var observer: Disposable?
}
