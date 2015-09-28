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
    public var elements: [ElementType]
    
    public init(elements: [ElementType], lock: LockType) {
        
        self.elements = elements
        self.dispatcher = Dispatcher(lock: lock)
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
    }
    
    public func replaceElementAtIndex(index: Int, withElement newElement: ElementType) {
        
        elements[index] = newElement
    }
}
