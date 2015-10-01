//
//  ArrayBindingStrategyType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal protocol ArrayBindingStrategyType {
    
    func reloadAllSections()
    func insertSections(sections: NSIndexSet)
    func reloadSections(sections: NSIndexSet)
    func deleteSections(sections: NSIndexSet)
    
    func reloadRowsInSections(sections: NSIndexSet)
    func insertRowsAtIndexPaths(paths: [NSIndexPath])
    func reloadRowsAtIndexPaths(paths: [NSIndexPath])
    func deleteRowsAtIndexPaths(paths: [NSIndexPath])
    
    func performBatchUpdate(update: () -> Void)
}
