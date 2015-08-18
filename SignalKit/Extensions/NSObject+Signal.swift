//
//  NSObject+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public extension NSObjectProtocol {
    
    /**
        Returns the available events for this type.
    
    */
    public func observe() -> SignalEvent<Self> {
        
        return SignalEvent(sender: self)
    }
}

public extension SignalEventType where Sender: NSObject {
    
    /**
        Observe for property change events using KVO.
        Use the value parameter to send the initial signal value and
        to specify the type of the observable property.
    
    */
    public func keyPath<T>(path: String, value: T) -> KVOSignal<T> {
        
        let signal = KVOSignal<T>(subject: sender, keyPath: path)
        
        signal.dispatch(value)
        
        return signal
    }
}
