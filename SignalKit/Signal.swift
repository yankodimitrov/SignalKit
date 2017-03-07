//
//  Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class Signal<T>: SignalProtocol {
    
    public typealias Value = T
    
    public var disposableSource: Disposable?
    internal fileprivate(set) var observers = Bag<(Value) -> Void>()
    internal fileprivate(set) var lock: Lock?
    
    
    /// Initialize Signal with optional Lock.
    ///
    /// - Parameter lock: Lock protocol implementation or nil.
    public init(lock: Lock? = nil) {
        
        self.lock = lock
    }
    
    
    /// Initialize optionally thread safe Signal
    ///
    /// - Parameter atomic: if true will return thread safe Signal using a mutex lock.
    public convenience init(atomic: Bool) {
        
        var lock: Lock?
        
        if atomic == true {
            lock = MutexLock()
        }
        
        self.init(lock: lock)
    }
    
    deinit {
        
        dispose()
    }
}

// MARK: - Observable

extension Signal {
    
    @discardableResult public func addObserver(_ observer: @escaping (Value) -> Void) -> Disposable {
        
        lock?.lock()
        
        let token = observers.insert(observer)
        
        lock?.unlock()
        
        return DisposableAction { [weak self] in
            
            self?.removeObserver(with: token)
        }
    }
    
    public func send(_ value: Value) {
        
        lock?.lock()
        
        for (_, observer) in observers {
            
            observer(value)
        }
        
        lock?.unlock()
    }
    
    internal func removeObserver(with token: RemovalToken) {
        
        lock?.lock()
        
        observers.remove(with: token)
        
        lock?.unlock()
    }
}
