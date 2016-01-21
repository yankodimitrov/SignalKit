//
//  CollectionChangeSetHandler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal final class CollectionChangeSetHandler {
    
    internal private(set) lazy var insertedSections = Set<Int>()
    internal private(set) lazy var updatedSections = Set<Int>()
    internal private(set) lazy var removedSections = Set<Int>()
    internal private(set) var shouldResetCollection = false
    
    internal private(set) lazy var insertedIndexPaths = [NSIndexPath]()
    internal private(set) lazy var updatedIndexPaths = [NSIndexPath]()
    internal private(set) lazy var removedIndexPaths = [NSIndexPath]()
    
    internal init() {}
}
