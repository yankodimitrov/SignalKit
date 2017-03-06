//
//  SignalValue.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class SignalValue<T>: SignalProtocol {
    
    public typealias Value = T
    
    public var disposableSource: Disposable?
    internal let signal: Signal<T>
    fileprivate var internalValue: T
    
    
    /// Updating the value will send the new value to the all observers of the Signal.
    public var value: T {
        get {
            
            signal.lock?.lock()
            let theValue = internalValue
            signal.lock?.unlock()
            
            return theValue
        }
        set {
            
            signal.lock?.lock()
            internalValue = newValue
            signal.lock?.unlock()
            
            signal.send(newValue)
        }
    }
    
    /// Initialize with initial value and optional Lock.
    /// The initial/current value will be sent to any new observer.
    ///
    /// - Parameters:
    ///   - value: the initial value.
    ///   - lock: Lock protocol implementaion or nil.
    public init(value: T, lock: Lock? = nil) {
        
        internalValue = value
        signal = Signal<T>(lock: lock)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Atomic signal

extension SignalValue {
    
    
    /// Create a thread safe SignalValue.
    ///
    /// - Parameter value: the initial value.
    /// - Returns: a thread safe SignalValue<T> with MutexLock.
    public class func atomic(value: T) -> SignalValue<T> {
        
        return SignalValue<T>(value: value, lock: MutexLock())
    }
}

// MARK: - Observable

extension SignalValue {
    
    @discardableResult public func addObserver(_ observer: @escaping (Value) -> Void) -> Disposable {
        
        let disposable = signal.addObserver(observer)
        
        signal.send(internalValue)
        
        return disposable
    }
    
    public func send(_ value: Value) {
        
        self.value = value
    }
}
