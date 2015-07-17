//
//  ObservableValue.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ObservableValue<T>: Observable {
    
    private let observable: ObservableOf<T>
    private let lock: LockType
    private var internalValue: T
    
    internal var observersCount: Int {
        return observable.observersCount
    }
    
    public var value: T {
        get {
            
            lock.lock()
            
            let v = internalValue
            
            lock.unlock()
            
            return v
        }
        
        set {
            
            lock.lock()
            
            internalValue = newValue
            observable.dispatch(newValue)
            
            lock.unlock()
        }
    }
    
    public init(value: T, observable: ObservableOf<T>, lock: LockType) {
        
        self.internalValue = value
        self.observable = observable
        self.lock = lock
    }
    
    public convenience init(_ value: T) {
        
        self.init(value: value, observable: ObservableOf<T>(), lock: SpinLock())
    }
    
    public convenience init(value: T, lock: LockType) {
        
        self.init(value: value, observable: ObservableOf<T>(), lock: lock)
    }
    
    public func addObserver(observer: T -> Void) -> Disposable {
        
        lock.lock()
        
        let item = observable.addObserver(observer)
        
        lock.unlock()
        
        return DisposableItem { [weak self] in
            
            self?.lock.lock()
            
            item.dispose()
            
            self?.lock.unlock()
        }
    }
    
    public func dispatch(value: T) {
        
        self.value = value
    }
    
    public func removeObservers() {
        
        lock.lock()
        
        observable.removeObservers()
        
        lock.unlock()
    }
}

public extension ObservableValue {
    
    /**
        Dispatch the value on a given dispatch queue
    
    */
    public func dispatch(value: T, on queue: SignalQueue) {
        
        dispatch_async(queue.dispatchQueue) { [weak self] in
            
            self?.value = value
        }
    }
}
