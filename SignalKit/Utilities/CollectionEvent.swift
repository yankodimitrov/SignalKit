//
//  CollectionEvent.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct CollectionEvent {
    
    public enum Element {
        case Section(Int)
        case Item(index: Int, section: Int)
    }
    
    public enum Operation {
        case Reset
        case Insert(Element)
        case Remove(Element)
        case Update(Element)
    }
    
    public var operations = Set<Operation>()
    
    public init() {}
}

extension CollectionEvent {
    
    /// Register that the data in the collection has been reset
    /// This will translate to table/collection view reload
    
    public mutating func sectionsReset() {
        
        operations.insert(.Reset)
    }
    
    /// Register that a new section has been inserted
    
    public mutating func sectionInsertedAt(index: Int) {
        
        operations.insert(.Insert(.Section(index)))
    }
    
    /// Register that a section has been removed
    
    public mutating func sectionRemovedAt(index: Int) {
        
        operations.insert(.Remove(.Section(index)))
    }
    
    /// Register that a section has been updated with new items
    
    public mutating func sectionUpdatedAt(index: Int) {
        
        operations.insert(.Update(.Section(index)))
    }
    
    /// Register that a new item has been inserted in the given section
    
    public mutating func itemInsertedAt(index: Int, inSection: Int) {
        
        operations.insert(.Insert(.Item(index: index, section: inSection)))
    }
    
    /// Register that an item has been removed from the given section
    
    public mutating func itemRemovedAt(index: Int, inSection: Int) {
        
        operations.insert(.Remove(.Item(index: index, section: inSection)))
    }
    
    /// Register that an item has been updated in the given section
    
    public mutating func itemUpdatedAt(index: Int, inSection: Int) {
        
        operations.insert(.Update(.Item(index: index, section: inSection)))
    }
}

extension CollectionEvent {
    
    public var containsResetOperation: Bool {
        
        return operations.contains(.Reset)
    }
}

// MARK: - Element Equatable

extension CollectionEvent.Element: Equatable {}

public func ==(lhs: CollectionEvent.Element, rhs: CollectionEvent.Element) -> Bool {
    
    switch (lhs, rhs) {
        
    case (let .Section(a), let .Section(b)):
        return a == b
    
    case (let .Item(indexA, sectionA), let .Item(indexB, sectionB)):
        return sectionA == sectionB && indexA == indexB
    
    default:
        return false
    }
}

// MARK: - Operation Equatable

extension CollectionEvent.Operation: Equatable {}

public func ==(lhs: CollectionEvent.Operation, rhs: CollectionEvent.Operation) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.Reset, .Reset):
        return true
        
    case (let .Insert(a), let .Insert(b)):
        return a == b
        
    case (let .Remove(a), let .Remove(b)):
        return a == b
        
    case (let .Update(a), let .Update(b)):
        return a == b
        
    default:
        return false
    }
}

// MARK: - Element Hashable

extension CollectionEvent.Element: Hashable {
    
    public var hashValue: Int {
        
        switch self {
        case let .Section(index):
            return 0.hashValue ^ index.hashValue
            
        case let .Item(index, section):
            return 1.hashValue ^ section.hashValue ^ index.hashValue
        }
    }
}

// MARK: - Operation Hashable

extension CollectionEvent.Operation: Hashable {
    
    public var hashValue: Int {
        
        switch self {
        case .Reset:
            return 0.hashValue
            
        case let .Insert(element):
            return 1.hashValue ^ element.hashValue
            
        case let .Remove(element):
            return 2.hashValue ^ element.hashValue
            
        case let .Update(element):
            return 3.hashValue ^ element.hashValue
        }
    }
}
