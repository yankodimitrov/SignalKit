//
//  Functions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

/// MARK: - Observe

/**
    Observe any Observable type

*/
public func observe<T: Observable>(observable: T, callback: (T.Item -> Void)? = nil) -> Signal<T.Item> {
    
    let signal = Signal<T.Item>(lock: SpinLock())
    
    let observer = ObserverOf<T>(observe: observable) { [weak signal] in
        
        signal?.dispatch($0)
    }
    
    if let callback = callback {
        
        signal.addObserver(callback)
    }
    
    signal.addDisposable(observer)
    
    return signal
}

/**
    Observe NSObject for a given keyPath

*/
public func observe<T>(#keyPath: String, #value: T, #object: NSObject, callback: (T -> Void)? = nil) -> Signal<T> {
    
    let signal = Signal<T>(lock: SpinLock())
    
    let observer = KVOObserver(observe: object, keyPath: keyPath) { [weak signal] value in
        
        if let value = value as? T {
            
            signal?.dispatch(value)
        }
    }
    
    signal.dispatch(value)
    
    if let callback = callback {
        
        signal.addObserver(callback)
    }
    
    signal.addDisposable(observer)
    
    return signal
}

/**
    Observe the default NSNotificationCenter for a given notification

*/
public func observe(notification: String, fromObject object: AnyObject? = nil, callback: (NSNotification -> Void)? = nil) -> Signal<NSNotification> {
    
    let signal = Signal<NSNotification>(dispatchRule: { _ in return { return nil }})
    
    let observer = NotificationObserver(observe: notification, fromObject: object) { [weak signal] in
        
        signal?.dispatch($0)
    }
    
    if let callback = callback {
        
        signal.addObserver(callback)
    }
    
    signal.addDisposable(observer)
    
    return signal
}

/// MARK: - Combine Latest

/**
    Combine the latest values of two signals A and B into a signal of type (A, B)

*/
public func combineLatest<A, B>(a: Signal<A>, b: Signal<B>) -> Signal<(A, B)> {
    
    let c = Signal<(A, B)>()
    
    let observer = CompoundObserver(signalA: a, signalB: b) { [weak c] in
        
        c?.dispatch($0)
    }
    
    c.addDisposable(observer)
    
    return c
}

/**
    Combine the latest values of three signals A, B and C into a signal of type (A, B, C)

*/
public func combineLatest<A, B, C>(a: Signal<A>, b: Signal<B>, c: Signal<C>) -> Signal<(A, B, C)> {
    
    return combineLatest( combineLatest(a, b), c)
        .map { ($0.0.0, $0.0.1, $0.1) }
}

/**
    Combine the latest values of four signals A, B, C and D into a signal of type (A, B, C, D)

*/
public func combineLatest<A, B, C, D>(a: Signal<A>, b: Signal<B>, c: Signal<C>, d: Signal<D>) -> Signal<(A, B, C, D)> {
    
    return combineLatest( combineLatest(a, b, c), d)
        .map { ($0.0.0, $0.0.1, $0.0.2, $0.1) }
}
