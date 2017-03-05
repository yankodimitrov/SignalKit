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
    
    deinit {
        
        dispose()
    }
}

// MARK: - Atomic signal

extension Signal {
    
    
    /// Create a thread safe Signal.
    ///
    /// - Returns: a thread safe Signal<T> with MutexLock.
    public class func atomic() -> Signal<T> {
        
        return Signal<T>(lock: MutexLock())
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
