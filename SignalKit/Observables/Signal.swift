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
}
