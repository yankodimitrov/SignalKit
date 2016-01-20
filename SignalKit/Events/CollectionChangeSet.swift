//
//  CollectionChangeSet.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct CollectionChangeSet {

    public private(set) lazy var collectionOperations = Set<ListOperation>()
    public private(set) lazy var sectionsOperations = [Int: Set<ListOperation>]()
    
    public init() {}
}

// MARK: - Collection Operations

extension CollectionChangeSet {
    
    public mutating func replaceAllSections() {
        
        collectionOperations.removeAll(keepCapacity: false)
        collectionOperations.insert(.Reset)
    }
    
    public mutating func insertSectionAtIndex(index: Int) {
        
        guard !collectionOperations.contains(.Reset) else { return }
        
        collectionOperations.insert(.Insert(index: index))
        sectionsOperations[index] = Set()
    }
    
    public mutating func updateSectionAtIndex(index: Int) {
        
        guard !collectionOperations.contains(.Reset) else { return }
        
        collectionOperations.insert(.Update(index: index))
    }
    
    public mutating func removeSectionAtIndex(index: Int) {
        
        guard !collectionOperations.contains(.Reset) else { return }
        
        collectionOperations.insert(.Remove(index: index))
    }
}

// MARK: - Sections Items Operations

extension CollectionChangeSet {
    
    private mutating func operationsSetForSection(section: Int) -> Set<ListOperation> {
        
        guard let section = sectionsOperations[section] else { return Set() }
        
        return section
    }
    
    public mutating func replaceItemsInSection(section: Int) {
        
        var operations = operationsSetForSection(section)
        
        operations.removeAll(keepCapacity: false)
        operations.insert(.Reset)
        
        sectionsOperations[section] = operations
    }
}
