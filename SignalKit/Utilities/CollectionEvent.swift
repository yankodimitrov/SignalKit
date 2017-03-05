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
        case section(Int)
        case item(index: Int, section: Int)
    }
    
    public enum Operation {
        case reset
        case insert(Element)
        case remove(Element)
        case update(Element)
    }
    
    public var operations = Set<Operation>()
    
    public init() {}
}

extension CollectionEvent {
    
    /// Register that the data in the collection has been reset
    /// This will translate to table/collection view reload
    
    public mutating func sectionsReset() {
        
        operations.insert(.reset)
    }
    
    /// Register that a new section has been inserted
    
    public mutating func sectionInsertedAt(_ index: Int) {
        
        operations.insert(.insert(.section(index)))
    }
    
    /// Register that a section has been removed
    
    public mutating func sectionRemovedAt(_ index: Int) {
        
        operations.insert(.remove(.section(index)))
    }
    
    /// Register that a section has been updated with new items
    
    public mutating func sectionUpdatedAt(_ index: Int) {
        
        operations.insert(.update(.section(index)))
    }
    
    /// Register that a new item has been inserted in the given section
    
    public mutating func itemInsertedAt(_ index: Int, inSection: Int) {
        
        operations.insert(.insert(.item(index: index, section: inSection)))
    }
    
    /// Register that an item has been removed from the given section
    
    public mutating func itemRemovedAt(_ index: Int, inSection: Int) {
        
        operations.insert(.remove(.item(index: index, section: inSection)))
    }
    
    /// Register that an item has been updated in the given section
    
    public mutating func itemUpdatedAt(_ index: Int, inSection: Int) {
        
        operations.insert(.update(.item(index: index, section: inSection)))
    }
}

extension CollectionEvent {
    
    public var containsResetOperation: Bool {
        
        return operations.contains(.reset)
    }
}

// MARK: - Element Equatable

extension CollectionEvent.Element: Equatable {}

public func ==(lhs: CollectionEvent.Element, rhs: CollectionEvent.Element) -> Bool {
    
    switch (lhs, rhs) {
        
    case (let .section(a), let .section(b)):
        return a == b
    
    case (let .item(indexA, sectionA), let .item(indexB, sectionB)):
        return sectionA == sectionB && indexA == indexB
    
    default:
        return false
    }
}

// MARK: - Operation Equatable

extension CollectionEvent.Operation: Equatable {}

public func ==(lhs: CollectionEvent.Operation, rhs: CollectionEvent.Operation) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.reset, .reset):
        return true
        
    case (let .insert(a), let .insert(b)):
        return a == b
        
    case (let .remove(a), let .remove(b)):
        return a == b
        
    case (let .update(a), let .update(b)):
        return a == b
        
    default:
        return false
    }
}

// MARK: - Element Hashable

extension CollectionEvent.Element: Hashable {
    
    public var hashValue: Int {
        
        switch self {
        case let .section(index):
            return 0.hashValue ^ index.hashValue
            
        case let .item(index, section):
            return 1.hashValue ^ section.hashValue ^ index.hashValue
        }
    }
}

// MARK: - Operation Hashable

extension CollectionEvent.Operation: Hashable {
    
    public var hashValue: Int {
        
        switch self {
        case .reset:
            return 0.hashValue
            
        case let .insert(element):
            return 1.hashValue ^ element.hashValue
            
        case let .remove(element):
            return 2.hashValue ^ element.hashValue
            
        case let .update(element):
            return 3.hashValue ^ element.hashValue
        }
    }
}
