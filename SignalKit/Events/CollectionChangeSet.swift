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
    
    public mutating func replacedAllSections() {
        
        collectionOperations.removeAll(keepCapacity: false)
        collectionOperations.insert(.Reset)
    }
    
    public mutating func insertedSectionAtIndex(index: Int) {
        
        guard !collectionOperations.contains(.Reset) else { return }
        
        collectionOperations.insert(.Insert(index: index))
        sectionsOperations[index] = Set()
    }
    
    public mutating func updatedSectionAtIndex(index: Int) {
        
        guard !collectionOperations.contains(.Reset) else { return }
        
        collectionOperations.insert(.Update(index: index))
    }
    
    public mutating func removedSectionAtIndex(index: Int) {
        
        guard !collectionOperations.contains(.Reset) else { return }
        
        collectionOperations.insert(.Remove(index: index))
    }
}

// MARK: - Sections Items Operations

extension CollectionChangeSet {
    
    private mutating func prepareOperationsSetForSection(section: Int) {
    
        guard sectionsOperations[section] == nil else { return }
        
        sectionsOperations[section] = Set()
    }
    
    public mutating func replacedItemsInSection(section: Int) {
        
        prepareOperationsSetForSection(section)
        
        sectionsOperations[section]?.insert(.Reset)
    }
}
