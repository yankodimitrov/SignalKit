//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable: class {
    
    associatedtype Value
    
    /// Add a new observer.
    ///
    /// - Parameter observer: Observer callback for new values.
    /// - Returns: Disposable which can be used to remove the observer.
    @discardableResult func addObserver(_ observer: @escaping (Value) -> Void) -> Disposable
    
    
    /// Sends a value to all observers
    ///
    /// - Parameter value: the value to send.
    func send(_ value: Value)
}

// MARK: - SendNext on a given queue

extension Observable {
    
    
    /// Sends a value to all observers on a given DispatchQueue.
    ///
    /// - Parameters:
    ///   - value: The value to send.
    ///   - queue: DispatchQueue on which to send the next value.
    public func send(_ value: Value, on queue: DispatchQueue) {
        
        queue.async { [weak self] in
            
            self?.send(value)
        }
    }
}
