//
//  NSObjectExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public extension NSObjectProtocol {
    
    /// Returns the available events for this type.
    ///
    /// - Returns: SignalEvent<Self>
    public func observe() -> SignalEvent<Self> {
        
        return SignalEvent(sender: self)
    }
}

public extension Event where Sender: NSObject {
    
    /// Observe the key path for new values.
    ///
    /// - Parameters:
    ///   - path: The key path for observe.
    ///   - value: The current value of the key path.
    /// - Returns: Signal<T> where T is the type of the current value of the key path.
    public func keyPath<T>(_ path: String, value: T) -> Signal<T> {
        
        let signal = Signal<T>()
        let observer = KeyPathObserver(subject: sender, keyPath: path)
        
        observer.keyPathCallback = { [weak signal] value in
            
            if let value = value as? T {
                
                signal?.send(value)
            }
        }
        
        signal.disposableSource = observer
        
        return signal
    }
}
