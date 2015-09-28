//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

public extension SignalType {
    
    /**
        Dispose the chain of signal operations.
    
    */
    public func dispose() {
        
        disposableSource?.dispose()
    }
    
    /**
        Adds a new observer to the signal to perform a side effect.
    
    */
    public func next(observer: ObservationType -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
    
    /**
        Transforms a signal ot type ObservationType to a signal of type U.
    
    */
    public func map<U>(transform: ObservationType -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.dispatch( transform($0) )
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Filters the dispatched by the signal values using a predicate.
    
    */
    public func filter(predicate: ObservationType -> Bool) -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>()
        
        addObserver { [weak signal] in
            
            if predicate($0) {
                
                signal?.dispatch($0)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Skips a certain number of dispatched by the signal values.
    
    */
    public func skip(var count: Int) -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>()
        
        addObserver { [weak signal] in
            
            if count <= 0 {
                
                signal?.dispatch($0)
            
            } else {
            
                count -= 1
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Delivers the signal on a given queue.
    
    */
    public func deliverOn(queue: SignalScheduler.Queue) -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>()
        let scheduler = SignalScheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.dispatchAsync {
                
                signal?.dispatch(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Sends only the latest values that are not followed by
        another values within the specified duration.
    
    */
    public func debounce(seconds: Double, queue: SignalScheduler.Queue = .MainQueue) -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>()
        var scheduler = SignalScheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.debounce(seconds) {
                
                signal?.dispatch(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Delays the dispatch of the signal.
    
    */
    public func delay(seconds: Double, queue: SignalScheduler.Queue = .MainQueue) -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>()
        let scheduler = SignalScheduler(queue: queue)
        
        addObserver { [weak signal] value in
            
            scheduler.delay(seconds) {
                
                signal?.dispatch(value)
            }
        }

        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Combine the latest values of the current signal A and
        another signal B in a signal of type (A, B).
    
    */
    public func combineLatestWith<T: SignalType>(signal: T) -> Signal<(ObservationType, T.ObservationType)> {
        
        let compoundSignal = Signal<(ObservationType, T.ObservationType)>()
        
        let observer = CompoundObserver(observableA: self, observableB: signal) {
            [weak compoundSignal] in
            
            compoundSignal?.dispatch($0)
        }
        
        compoundSignal.disposableSource = observer
        
        return compoundSignal
    }
    
    /**
        Bind the value to an Observable of the same type
    
    */
    public func bindTo<T: Observable where T.ObservationType == ObservationType>(observable: T) -> Self {
        
        addObserver { [weak observable] in
        
            observable?.dispatch($0)
        }
        
        return self
    }
}

// MARK: - Distinct

public extension SignalType where ObservationType: Equatable {
    
    /**
        Dispatches the new value only if it is not equal to the previous one.
    
    */
    public func distinct() -> Signal<ObservationType> {
        
        let signal = Signal<ObservationType>()
        var lastValue: ObservationType?
        
        addObserver { [weak signal] value in
            
            if lastValue != value {
                
                lastValue = value
                signal?.dispatch(value)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
}

// MARK: - SignalType (Bool, Bool)

public extension SignalType where ObservationType == (Bool, Bool) {
    
    /**
        Sends true if all values in a signal of tuple type (Bool, Bool)
        are matching the predicate function.
    
    */
    public func all(predicate: Bool -> Bool) -> Signal<Bool> {
        
        return self.map { predicate($0.0) && predicate($0.1) }
    }
    
    /**
        Sends true if at least one value in a signal of tuple type (Bool, Bool)
        matches the predicate function.
    
    */
    public func some(predicate: Bool -> Bool) -> Signal<Bool> {
        
        return self.map { predicate($0.0) || predicate($0.1) }
    }
}

// MARK: - SignalType (Bool, Bool, Bool)

public extension SignalType where ObservationType == (Bool, Bool, Bool) {
    
    /**
        Sends true if all values in a signal of tuple type (Bool, Bool, Bool)
        are matching the predicate function.
    
    */
    public func all(predicate: Bool -> Bool) -> Signal<Bool> {
        
        return self.map { predicate($0.0) && predicate($0.1) && predicate($0.2) }
    }
    
    /**
        Sends true if at least one value in a signal of tuple type (Bool, Bool, Bool)
        matches the predicate function.
    
    */
    public func some(predicate: Bool -> Bool) -> Signal<Bool> {
        
        return self.map { predicate($0.0) || predicate($0.1) || predicate($0.2) }
    }
}

// MARK: - Combine Latest

/**
    Combine the latest values of signal A and signal B in a signal of type (A, B).

*/
public func combineLatest<A: SignalType, B: SignalType>(a: A, _ b: B) -> Signal<(A.ObservationType, B.ObservationType)> {
    
    return a.combineLatestWith(b)
}

/**
    Combine the latest values of three signals A, B and C in a signal of type (A, B, C).

*/
public func combineLatest<A: SignalType, B: SignalType, C: SignalType>(a: A, _ b: B, _ c: C) -> Signal<(A.ObservationType, B.ObservationType, C.ObservationType)> {
    
    return combineLatest( combineLatest(a, b), c).map { ($0.0.0, $0.0.1, $0.1) }
}
