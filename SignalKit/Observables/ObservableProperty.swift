//
//  ObservableProperty.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ObservableProperty<T>: Observable {
    public typealias ObservationType = T
    
    private var internalValue: ObservationType
    private let lock: LockType
    
    public let dispatcher: Dispatcher<ObservationType>
    
    public var value: ObservationType {
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
    
    public init(value: ObservationType, lock: LockType) {
        
        self.internalValue = value
        self.lock = lock
        self.dispatcher = Dispatcher<ObservationType>(lock: lock)
    }
    
    public convenience init(_ value: ObservationType) {
        
        self.init(value: value, lock: SpinLock())
    }
    
    public func dispatch(item: ObservationType) {
        
        value = item
    }
}

public extension ObservableProperty {
    
    /**
        Observe the observable property for value changes
    
    */
    public func observe() -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>(lock: SpinLock())
        
        signal.observe(self)
        
        return signal
    }
}
