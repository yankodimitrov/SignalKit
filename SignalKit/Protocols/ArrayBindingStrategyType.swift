//
//  ArrayBindingStrategyType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal protocol ArrayBindingStrategyType {
    
    func reloadSections()
    func reloadRowsInSection(section: Int)
    
    func insertSections(sections: NSIndexSet)
    func insertRowsAtIndexPaths(paths: [NSIndexPath])
    
    func reloadSection(section: NSIndexSet)
    func reloadRowsAtIndexPaths(paths: [NSIndexPath], inSection: Int)
    
    func deleteSections(sections: NSIndexSet)
    func deleteRowsAtIndexPaths(paths: [NSIndexPath], inSection: Int)
    
    func performBatchUpdate(update: () -> Void)
}
