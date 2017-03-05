//
//  SignalValue.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class SignalValue<T>: SignalType {
    public typealias Value = T
    
    public var disposableSource: Disposable?
    fileprivate let signal = Signal<T>()
    fileprivate var mutex = pthread_mutex_t()
    fileprivate var internalValue: T
    
    public var value: T {
        get {
            pthread_mutex_lock(&mutex)
            let theValue = internalValue
            pthread_mutex_unlock(&mutex)
            
            return theValue
        }
        set {
            pthread_mutex_lock(&mutex)
            internalValue = newValue
            pthread_mutex_unlock(&mutex)
            
            signal.send(newValue)
        }
    }
    
    public init(value: T) {
        
        internalValue = value
    }
    
    deinit {
        
        dispose()
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
