//
//  MockBindingStrategy.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/30/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
@testable import SignalKit

internal class MockBindingStrategy: ArrayBindingStrategyType {
    
    var isReloadAllSectionsCalled = false
    var sectionsInsertCallback: ((sections: NSIndexSet) -> Void)?
    var sectionsReloadCallback: ((sections: NSIndexSet) -> Void)?
    var sectionsDeleteCallback: ((sections: NSIndexSet) -> Void)?
    
    var reloadRowsInSectionCallback: ((sections: NSIndexSet) -> Void)?
    var rowsInsertCallback: ((paths: [NSIndexPath]) -> Void)?
    var rowsReloadCallback: ((paths: [NSIndexPath]) -> Void)?
    var rowsDeleteCallback: ((paths: [NSIndexPath]) -> Void)?
    
    var isBatchUpdateCalled = false
    
    func reloadAllSections() {
        
        isReloadAllSectionsCalled = true
    }
    
    func reloadRowsInSections(sections: NSIndexSet) {
        
        reloadRowsInSectionCallback?(sections: sections)
    }
    
    func insertSections(sections: NSIndexSet) {
        
        sectionsInsertCallback?(sections: sections)
    }
    
    func insertRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        rowsInsertCallback?(paths: paths)
    }
    
    func reloadSections(sections: NSIndexSet) {
        
        sectionsReloadCallback?(sections: sections)
    }
    
    func reloadRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        rowsReloadCallback?(paths: paths)
    }
    
    func deleteSections(sections: NSIndexSet) {
        
        sectionsDeleteCallback?(sections: sections)
    }
    
    func deleteRowsAtIndexPaths(paths: [NSIndexPath]) {
        
        rowsDeleteCallback?(paths: paths)
    }
    
    func performBatchUpdate(update: () -> Void) {
        
        isBatchUpdateCalled = true
        update()
    }
}
