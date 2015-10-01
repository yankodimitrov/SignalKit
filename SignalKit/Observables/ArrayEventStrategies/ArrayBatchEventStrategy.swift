//
//  ArrayBatchEventStrategy.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal final class ArrayBatchEventStrategy: ArrayEventStrategyType {
    
    private lazy var insertedIndexes = Set<Int>()
    private lazy var updatedIndexes = Set<Int>()
    private lazy var removedIndexes = Set<Int>()
    private var elements: [Int]
    private var shouldReset = false
    
    internal var indexes: [Int] {
        return elements
    }
    
    var event: ObservableArrayEvent {
        
        guard !shouldReset else { return .Reset }
        
        return .Batch(inserted: insertedIndexes, updated: updatedIndexes, removed: removedIndexes)
    }
    
    init(elementsCount: Int) {
        
        elements = Array(0..<elementsCount)
    }
    
    private func updateIndexesInSet(inout set: Set<Int>, greatherThan index: Int, transform: (Int) -> Int) {
        
        guard !set.isEmpty else { return }
        
        let indexesToUpdate = set.filter { $0 >= index }
        
        if !indexesToUpdate.isEmpty {
            
            set.subtractInPlace(indexesToUpdate)
            set.unionInPlace(indexesToUpdate.map(transform))
        }
    }
    
    func insertedElementsAtIndex(index: Int, count: Int) {
        
        guard !shouldReset else { return }
        
        let newElements = Array<Int>(count: count, repeatedValue: -1)
        
        updateIndexesInSet(&insertedIndexes, greatherThan: index) { $0 + count }
        
        elements.insertContentsOf(newElements, at: index)
        insertedIndexes.unionInPlace(Array<Int>(index..<index + count))
    }
    
    func updatedElementAtIndex(index: Int) {
        
        guard !shouldReset else { return }
        guard elements[index] >= 0 else { return }
        
        updatedIndexes.insert(elements[index])
    }
    
    func removedElementAtIndex(index: Int) {
        
        guard !shouldReset else { return }
        
        defer {
            updateIndexesInSet(&insertedIndexes, greatherThan: index) { $0 - 1 }
            elements.removeAtIndex(index)
        }
        
        guard elements[index] >= 0 else {
            insertedIndexes.remove(index)
            return
        }
        
        updatedIndexes.remove(elements[index])
        removedIndexes.insert(elements[index])
    }
    
    func replacedAllElements() {
        
        shouldReset = true
    }
}
