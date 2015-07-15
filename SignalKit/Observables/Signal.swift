//
//  Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class Signal<T>: SignalType, Observable {
    
    private let observable: ObservableOf<T>
    private let lock: LockType?
    private lazy var disposables = [Disposable]()
    
    internal var observersCount: Int {
        return observable.observersCount
    }
    
    internal var disposablesCount: Int {
        return disposables.count
    }
    
    public var sourceSignal: SignalType?
    
    public init(observable: ObservableOf<T>, lock: LockType?) {
        
        self.observable = observable
        self.lock = lock
    }
    
    public convenience init() {
        
        self.init(observable: ObservableOf<T>(), lock: nil)
    }
    
    public convenience init(lock: LockType) {
        
        self.init(observable: ObservableOf<T>(), lock: lock)
    }
    
    public convenience init(dispatchRule: (T) -> () -> T?) {
        
        let lock = SpinLock()
        let observable = ObservableOf<T>(dispatchRule: dispatchRule)
        
        self.init(observable: observable, lock: lock)
    }
    
    deinit {
        
        dispose()
    }
    
    public func addObserver(observer: T -> Void) -> Disposable {
        
        lock?.lock()
        
        let item = observable.addObserver(observer)
        
        lock?.unlock()
        
        return DisposableItem { [weak self] in
            
            self?.lock?.lock()
            
            item.dispose()
            
            self?.lock?.unlock()
        }
    }
    
    public func dispatch(value: T) {
        
        lock?.lock()
        
        observable.dispatch(value)
        
        lock?.unlock()
    }
    
    public func removeObservers() {
        
        lock?.lock()
        
        observable.removeObservers()
        
        lock?.unlock()
    }
    
    public func addDisposable(disposable: Disposable) {
        
        lock?.lock()
        
        disposables.append(disposable)
        
        lock?.unlock()
    }
    
    public func dispose() {
        
        lock?.lock()
        
        disposables.map { $0.dispose() }
        disposables.removeAll(keepCapacity: false)
        observable.removeObservers()
        
        lock?.unlock()
        
        sourceSignal?.dispose()
    }
}

public extension Signal {
    
    /**
        Add a new observer to a signal to perform a side effect
    
    */
    public func next(observer: T -> Void) -> Signal<T> {
        
        addObserver(observer)
        
        return self
    }
    
    /**
        Add a signal or a chain of signals to a signal container.
    
    */
    public func addTo(container: SignalContainerType) -> Disposable {
        
        return container.addSignal(self)
    }
    
    /**
        Transform a signal ot type T to a signal of type U
    
    */
    public func map<U>(transform: T -> U) -> Signal<U> {
        
        let b = Signal<U>()
        
        addObserver { [weak b] in
            
            b?.dispatch( transform($0) )
        }
        
        b.sourceSignal = self
        
        return b
    }
    
    /**
        Filter the dispatched by the signal values using a predicate
    
    */
    public func filter(predicate: T -> Bool) -> Signal<T> {
        
        let b = Signal<T>()
        
        addObserver { [weak b] in
            
            if predicate($0) {
                
                b?.dispatch($0)
            }
        }
        
        b.sourceSignal = self
        
        return b
    }
    
    /**
        Skip a certain number of dispatched by the signal values
    
    */
    public func skip(count: Int) -> Signal<T> {
        
        let b = Signal<T>()
        var counter = count + 1
        
        addObserver { [weak b] in
            
            if counter <= 0 {
                
                b?.dispatch($0)
                
            } else {
                
                counter -= 1
            }
        }
        
        b.sourceSignal = self
        
        return b
    }
}
