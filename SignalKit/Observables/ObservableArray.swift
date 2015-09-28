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