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
    func reloadRowsInSections(sections: NSIndexSet)
    
    func insertSections(sections: NSIndexSet)
    func insertRowsAtIndexPaths(paths: [NSIndexPath])
    
    func reloadSections(sections: NSIndexSet)
    func reloadRowsAtIndexPaths(paths: [NSIndexPath])
    
    func deleteSections(sections: NSIndexSet)
    func deleteRowsAtIndexPaths(paths: [NSIndexPath])
    
    func performBatchUpdate(update: () -> Void)
}
