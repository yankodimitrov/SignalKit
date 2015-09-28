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
    public let dispatcher: Dispatcher<ObservationType>
    
    public var value: ObservationType {
        didSet {
            dispatcher.dispatch(value)
        }
    }
    
    public init(value: ObservationType, lock: LockType) {
        
        self.value = value
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
        
        let signal = Signal<ObservationType>()
        
        signal.observe(self)
        
        return signal
    }
}
