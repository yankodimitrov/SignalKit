//
//  ObservableArray.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 9/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public enum ObservableArrayEvent {
    case Reset
    case Insert (Set<Int>)
    case Update (Set<Int>)
    case Remove (Set<Int>)
    case Batch (inserted: Set<Int>, updated: Set<Int>, removed: Set<Int>)
}

public final class ObservableArray<ElementType>: Observable {
    
    public typealias ObservationType = ObservableArrayEvent
    public let dispatcher: Dispatcher<ObservableArrayEvent>
    
    public var elements: [ElementType] {
        didSet {
            eventStrategy.replacedAllElements()
        }
    }
    
    internal var eventStrategy: ArrayEventStrategyType
    
    public init(elements: [ElementType], lock: LockType) {
        
        self.elements = elements
        self.dispatcher = Dispatcher(lock: lock)
        self.eventStrategy = ArraySerialEventStrategy(dispatcher: dispatcher)
    }
    
    public convenience init(_ elements: [ElementType]) {
        
        self.init(elements: elements, lock: SpinLock())
    }
    
    public convenience init() {
        
        self.init([ElementType]())
    }
}

public extension ObservableArray {
    
    public func insertElements(newElements: [ElementType], atIndex index: Int) {
        
        elements.insertContentsOf(newElements, at: index)
        eventStrategy.insertedElementsAtIndex(index, count: newElements.count)
    }
    
    public func replaceElementAtIndex(index: Int, withElement newElement: ElementType) {
        
        elements[index] = newElement
        eventStrategy.updatedElementAtIndex(index)
    }
    
    public func removeElementAtIndex(index: Int) -> ElementType {
        
        let element = elements.removeAtIndex(index)
        
        eventStrategy.removedElementAtIndex(index)
        
        return element
    }
    
    public func removeAllElements(keepCapacity: Bool = false) {
        
        elements.removeAll(keepCapacity: keepCapacity)
        eventStrategy.replacedAllElements()
    }
}

extension ObservableArray: CollectionType {
    
    public var startIndex: Int {
        return elements.startIndex
    }
    
    public var endIndex: Int {
        return elements.endIndex
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var count: Int {
        return elements.count
    }
    
    public func underestimateCount() -> Int {
        return elements.underestimateCount()
    }
    
    public func generate() -> IndexingGenerator<Array<ElementType>> {
        return elements.generate()
    }
    
    public subscript(index: Int) -> ElementType {
        get {
            return elements[index]
        }
        set {
            replaceElementAtIndex(index, withElement: newValue)
        }
    }
}
