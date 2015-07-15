//
//  ObservableOf.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ObservableOf<T>: Observable {
    typealias ObservationType = T
    
    private lazy var observers = Bag<SinkOf<T>>()
    private let dispatchRule: (T) -> () -> T?
    private var dispatchValue: ( () -> T? )?
    
    internal var observersCount: Int {
        return observers.count
    }
    
    /**
        Initialize with custom dispatch rule
    
        The dispatch rule is used to determine if the observable should
        dispatch the latest value to the newly added observer.
    
    */
    public init(dispatchRule: (T) -> () -> T?) {
        
        self.dispatchRule = dispatchRule
    }
    
    /**
        Initialize with dispatch rule to dispatch the latest value.
    
        - Note: Reference types will be retained.
    
    */
    public convenience init() {
        
        self.init(dispatchRule: { v in { return v } })
    }
    
    public func addObserver(observer: T -> Void) -> Disposable {
        
        let token = observers.insert( SinkOf(observer) )
        
        if let value = dispatchValue?() {
            
            observer(value)
        }
        
        return DisposableItem { [weak self] in
            
            self?.observers.removeItemWithToken(token)
        }
    }
    
    public func dispatch(value: T) {
        
        for (key, observer) in observers {
            
            observer.put(value)
        }
        
        dispatchValue = dispatchRule(value)
    }
    
    public func removeObservers() {
        
        observers.removeItems()
    }
}
