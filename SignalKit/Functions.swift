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
