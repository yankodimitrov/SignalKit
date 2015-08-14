//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: class, Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

public extension SignalType {
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
    
    /**
        Adds a new observer to a signal to perform a side effect
    
    */
    public func next(observer: Item -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
    
    /**
        Transforms a signal ot type Item to a signal of type U
    
    */
    public func map<U>(transform: Item -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.dispatch( transform($0) )
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Filters the dispatched by the signal values using a predicate
    
    */
    public func filter(predicate: Item -> Bool) -> Signal<Item> {
        
        let signal = Signal<Item>()
        
        addObserver { [weak signal] in
            
            if predicate($0) {
                
                signal?.dispatch($0)
            }
        }
        
        signal.disposableSource = self
        
        return signal
    }
    
    /**
        Skips a certain number of dispatched by the signal values
    
    */
    public func skip(var count: Int) -> Signal<Item> {
        
        let signal = Signal<Item>()
        
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
        Delivers the signal on a given queue
    
    */
    public func deliverOn(queue: SignalScheduler.Queue) -> Signal<Item> {
        
        let signal = Signal<Item>()
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
        another values within the specified duration
    
    */
    public func debounce(seconds: Double, queue: SignalScheduler.Queue = .MainQueue) -> Signal<Item> {
        
        let signal = Signal<Item>()
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
        Delays the dispatch of the signal
    
    */
    public func delay(seconds: Double, queue: SignalScheduler.Queue = .MainQueue) -> Signal<Item> {
        
        let signal = Signal<Item>()
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
        Stores a signal or a chain of signal operations in a container
    
    */
    public func addTo(container: SignalContainerType) -> Disposable {
        
        return container.addSignal(self)
    }
}
