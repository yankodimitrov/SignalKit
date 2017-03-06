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
    
    /// Dispose the whole chain of Signals.
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
}

// MARK: - Next

extension SignalProtocol {
    
    /// Add a new observer to a Signal
    ///
    /// - Parameter observer: Observer callback for new values.
    /// - Returns: Signal of the same type.
    public func next(_ observer: @escaping (Value) -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
}

// MARK: - Map

extension SignalProtocol {
    
    /// Transform the Signal to a Signal with different type.
    ///
    /// - Parameter transform: Function that accepts the new value and transforms it to a new type.
    /// - Returns: Signal with the type of the transform function result.
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
    
    /// Filter the Signal value with a predicate.
    ///
    /// - Parameter predicate: Function that returns true if the new value matches a certain condition.
    /// - Returns: Signal of the same type.
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
    
    /// Skip a number of sent values.
    /// Note: It skips only the first N number of sent values.
    ///
    /// - Parameter count: The number of sent values to skip.
    /// - Returns: Signal of the same type.
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
    
    /// Observe the Signal on a given DispatchQueue.
    ///
    /// - Parameter queue: The DispatchQueue on which to receive next values.
    /// - Returns: Signal of the same type.
    public func observe(on queue: DispatchQueue) -> Signal<Value> {
        
        let signal = Signal<Value>()
        
        addObserver { [weak signal] value in
            
            queue.async {
                
                signal?.send(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Debounce

extension SignalProtocol {
    
    /// Sends only the latest value that is not followed by value in a given timeframe.
    ///
    /// - Parameters:
    ///   - seconds: The timeframe in which to wait for new values before we send the most recent one.
    ///   - queue: The DispatchQueue on which to receive the value. Defaults to main.
    /// - Returns: Signal of the same type.
    public func debounce(_ seconds: Double, on queue: DispatchQueue = .main) -> Signal<Value> {
        
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
    
    /// Delay the send value.
    ///
    /// - Parameters:
    ///   - seconds: The delay time.
    ///   - queue: The DispatchQueue on which to reveive the value. Defaults to main.
    /// - Returns: Signal of the same type.
    public func delay(_ seconds: Double, on queue: DispatchQueue = .main) -> Signal<Value> {
        
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
    
    /// Bind the value to a Signal of the same type.
    ///
    /// - Parameter signal: The Signal to which to send new values.
    /// - Returns: Signal of the same type.
    public func bindTo<T: SignalProtocol>(_ signal: T) -> Self where T.Value == Value {
        
        addObserver { [weak signal] in
        
            signal?.send($0)
        }
        
        return self
    }
}

// MARK: - Distinct

extension SignalProtocol where Value: Equatable {
    
    /// Sends the value only if its not equal to the previous one.
    ///
    /// - Returns: Signal of the same type.
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
    
    /// Combine the latest values of two signals to a Signal of type (A, B).
    ///
    /// - Parameter signal: The Signal to combine with.
    /// - Returns: Signal of the type Signal<(A, B)>.
    public func combineLatest<T: SignalProtocol>(with signal: T) -> Signal<(Value, T.Value)> {
        
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
    
    /// Sends true if all values in a Signal of type (Bool, Bool) are matching the predicate.
    ///
    /// - Parameter predicate: The predicate function.
    /// - Returns: Signal of type Bool
    public func allEqual(_ predicate: @escaping (Bool) -> Bool) -> Signal<Bool> {
        
        return map { predicate($0.0) && predicate($0.1) }
    }
}

// MARK: - SomeEqual

extension SignalProtocol where Value == (Bool, Bool) {
    
    /// Sends true if at least one value in a Signal of type (Bool, Bool) is matching the predicate.
    ///
    /// - Parameter predicate: The predicate function.
    /// - Returns: Signal of type Bool
    public func someEqual(_ predicate: @escaping (Bool) -> Bool) -> Signal<Bool> {
        
        return map { predicate($0.0) || predicate($0.1) }
    }
}
