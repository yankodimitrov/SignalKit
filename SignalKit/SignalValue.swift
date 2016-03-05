//
//  SignalValue.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class SignalValue<T>: SignalType {
    public typealias ObservationValue = T
    
    public var disposableSource: Disposable?
    private let signal = Signal<T>()
    private var mutex = pthread_mutex_t()
    private var internalValue: T
    
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
            
            signal.sendNext(newValue)
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
    
    public func addObserver(observer: ObservationValue -> Void) -> Disposable {
        
        let disposable = signal.addObserver(observer)
        
        signal.sendNext(internalValue)
        
        return disposable
    }
    
    public func sendNext(value: ObservationValue) {
        
        self.value = value
    }
}
