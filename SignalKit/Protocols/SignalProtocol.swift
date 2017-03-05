//
//  SignalProtocol.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalProtocol: Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

// MARK: - Disposable

extension SignalProtocol {
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
}

// MARK: - Next

extension SignalProtocol {
    
    /// Add a new observer to a Signal
    
    public func next(_ observer: @escaping (Value) -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
}

// MARK: - Map

extension SignalProtocol {
    
    /// Transform a Signal of type ObservationValue to a Signal of type U
    
    public func map<U>(_ transform: @escaping (Value) -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.send(transform($0))
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Filter

extension SignalProtocol {
    
    /// Filter the Signal value using a predicate
    
    public func filter(_ predicate: @escaping (Value) -> Bool) -> Signal<Value> {
        
        let signal = Signal<Value>()
        
        addObserver { [weak signal] in
            
            if predicate($0) {
                
                signal?.send($0)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Skip

extension SignalProtocol {
    
    /// Skip a number of sent values
    
    public func skip(_ count: Int) -> Signal<Value> {
        var count = count
        
        let signal = Signal<Value>()
        
        addObserver { [weak signal] in
        
            guard count <= 0 else { count -= 1; return }
            
            signal?.send($0)
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - ObserveOn

extension SignalProtocol {
    
    /// Observe the Signal on a given queue
    
    public func observeOn(_ queue: SchedulerQueue) -> Signal<Value> {
        
        let signal = Signal<Value>()
        let scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.async {
                
                signal?.send(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Debounce

extension SignalProtocol {
    
    /// Sends only the latest values that are not followed by another value in a given timeframe
    
    public func debounce(_ seconds: Double, queue: SchedulerQueue = .mainQueue) -> Signal<Value> {
        
        let signal = Signal<Value>()
        var scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.debounce(seconds) {
                
                signal?.send(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Delay

extension SignalProtocol {
    
    /// Delay the sent value
    
    public func delay(_ seconds: Double, queue: SchedulerQueue = .mainQueue) -> Signal<Value> {
        
        let signal = Signal<Value>()
        let scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
        
            scheduler.delay(seconds) {
                
                signal?.send(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - BindTo

extension SignalProtocol {
    
    /// Bind the value to a signal of the same type
    
    public func bindTo<T: SignalProtocol>(_ signal: T) -> Self where T.Value == Value {
        
        addObserver { [weak signal] in
        
            signal?.send($0)
        }
        
        return self
    }
}

// MARK: - Distinct

extension SignalProtocol where Value: Equatable {
    
    /// Send the value only if not equal to the previous one
    
    public func distinct() -> Signal<Value> {
        
        let signal = Signal<Value>()
        var lastValue: Value?
        
        addObserver { [weak signal] value in
            
            if value != lastValue {
                
                lastValue = value
                signal?.send(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - CombineLatestWith

extension SignalProtocol {
    
    /// Combine the latest values of two signals to a signal of type (A, B)
    
    public func combineLatestWith<T: SignalProtocol>(_ signal: T) -> Signal<(Value, T.Value)> {
        
        let compoundSignal = Signal<(Value, T.Value)>()
        var lastValueA: Value?
        var lastValueB: T.Value?
        
        addObserver { [weak compoundSignal] in
            
            lastValueA = $0
            
            guard let lastValueB = lastValueB else { return }
            
            compoundSignal?.send(($0, lastValueB))
        }
        
        signal.addObserver { [weak compoundSignal] in
        
            lastValueB = $0
            
            guard let lastValueA = lastValueA else { return }
            
            compoundSignal?.send((lastValueA, $0))
        }
        
        compoundSignal.disposableSource = self
        
        return compoundSignal
    }
}

// MARK: - AllEqual

extension SignalProtocol where Value == (Bool, Bool) {
    
    /// Send true if all values in a signal of type (Bool, Bool) are matching the predicate function
    
    public func allEqual(_ predicate: @escaping (Bool) -> Bool) -> Signal<Bool> {
        
        return map { predicate($0.0) && predicate($0.1) }
    }
}

// MARK: - SomeEqual

extension SignalProtocol where Value == (Bool, Bool) {
    
    /// Send true if at least one value in a signal of type (Bool, Bool) matches the predicate function
    
    public func someEqual(_ predicate: @escaping (Bool) -> Bool) -> Signal<Bool> {
        
        return map { predicate($0.0) || predicate($0.1) }
    }
}
