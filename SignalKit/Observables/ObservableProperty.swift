//
//  ObservableProperty.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ObservableProperty<T>: Observable {
    public typealias Item = T
    
    private var internalValue: Item
    private let lock: LockType
    
    public let dispatcher: Dispatcher<Item>
    
    public var value: Item {
        get {
            lock.lock()
            let theValue = internalValue
            lock.unlock()
            
            return theValue
        }
        set {
            lock.lock()
            internalValue = newValue
            lock.unlock()
            
            dispatcher.dispatch(newValue)
        }
    }
    
    public init(value: Item, lock: LockType) {
        
        self.internalValue = value
        self.lock = lock
        self.dispatcher = Dispatcher<Item>(lock: lock)
    }
    
    public convenience init(_ value: Item) {
        
        self.init(value: value, lock: SpinLock())
    }
    
    public func dispatch(item: Item) {
        
        value = item
    }
}

public extension ObservableProperty {
    
    /**
        Observes the observable property for value changes
    
    */
    public func observe() -> Signal<Item> {
        
        let signal = Signal<Item>(lock: SpinLock())
        
        signal.observe(self)
        
        return signal
    }
}
