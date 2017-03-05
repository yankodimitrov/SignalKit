//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

// MARK: - Disposable

extension SignalType {
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
}

// MARK: - Next

extension SignalType {
    
    /// Add a new observer to a Signal
    
    public func next(_ observer: @escaping (ObservationValue) -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
}

// MARK: - Map

extension SignalType {
    
    /// Transform a Signal of type ObservationValue to a Signal of type U
    
    public func map<U>(_ transform: @escaping (ObservationValue) -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.sendNext(transform($0))
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Filter

extension SignalType {
    
    /// Filter the Signal value using a predicate
    
    public func filter(_ predicate: @escaping (ObservationValue) -> Bool) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        
        addObserver { [weak signal] in
            
            if predicate($0) {
                
                signal?.sendNext($0)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Skip

extension SignalType {
    
    /// Skip a number of sent values
    
    public func skip(_ count: Int) -> Signal<ObservationValue> {
        var count = count
        
        let signal = Signal<ObservationValue>()
        
        addObserver { [weak signal] in
        
            guard count <= 0 else { count -= 1; return }
            
            signal?.sendNext($0)
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - ObserveOn

extension SignalType {
    
    /// Observe the Signal on a given queue
    
    public func observeOn(_ queue: SchedulerQueue) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        let scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.async {
                
                signal?.sendNext(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Debounce

extension SignalType {
    
    /// Sends only the latest values that are not followed by another value in a given timeframe
    
    public func debounce(_ seconds: Double, queue: SchedulerQueue = .mainQueue) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        var scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.debounce(seconds) {
                
                signal?.sendNext(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - Delay

extension SignalType {
    
    /// Delay the sent value
    
    public func delay(_ seconds: Double, queue: SchedulerQueue = .mainQueue) -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        let scheduler = Scheduler(queue: queue)
        
        addObserver { [weak signal] value in
        
            scheduler.delay(seconds) {
                
                signal?.sendNext(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - BindTo

extension SignalType {
    
    /// Bind the value to a signal of the same type
    
    public func bindTo<T: SignalType>(_ signal: T) -> Self where T.ObservationValue == ObservationValue {
        
        addObserver { [weak signal] in
        
            signal?.sendNext($0)
        }
        
        return self
    }
}

// MARK: - Distinct

extension SignalType where ObservationValue: Equatable {
    
    /// Send the value only if not equal to the previous one
    
    public func distinct() -> Signal<ObservationValue> {
        
        let signal = Signal<ObservationValue>()
        var lastValue: ObservationValue?
        
        addObserver { [weak signal] value in
            
            if value != lastValue {
                
                lastValue = value
                signal?.sendNext(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - CombineLatestWith

extension SignalType {
    
    /// Combine the latest values of two signals to a signal of type (A, B)
    
    public func combineLatestWith<T: SignalType>(_ signal: T) -> Signal<(ObservationValue, T.ObservationValue)> {
        
        let compoundSignal = Signal<(ObservationValue, T.ObservationValue)>()
        var lastValueA: ObservationValue?
        var lastValueB: T.ObservationValue?
        
        addObserver { [weak compoundSignal] in
            
            lastValueA = $0
            
            guard let lastValueB = lastValueB else { return }
            
            compoundSignal?.sendNext(($0, lastValueB))
        }
        
        signal.addObserver { [weak compoundSignal] in
        
            lastValueB = $0
            
            guard let lastValueA = lastValueA else { return }
            
            compoundSignal?.sendNext((lastValueA, $0))
        }
        
        compoundSignal.disposableSource = self
        
        return compoundSignal
    }
}

// MARK: - AllEqual

extension SignalType where ObservationValue == (Bool, Bool) {
    
    /// Send true if all values in a signal of type (Bool, Bool) are matching the predicate function
    
    public func allEqual(_ predicate: @escaping (Bool) -> Bool) -> Signal<Bool> {
        
        return map { predicate($0.0) && predicate($0.1) }
    }
}

// MARK: - SomeEqual

extension SignalType where ObservationValue == (Bool, Bool) {
    
    /// Send true if at least one value in a signal of type (Bool, Bool) matches the predicate function
    
    public func someEqual(_ predicate: @escaping (Bool) -> Bool) -> Signal<Bool> {
        
        return map { predicate($0.0) || predicate($0.1) }
    }
}
