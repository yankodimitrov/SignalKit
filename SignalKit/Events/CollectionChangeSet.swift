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
}
