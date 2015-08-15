//
//  NSObject+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public extension NSObject {
    
    /**
        Observes for property change events using KVO.
        Use the value parameter to send the initial signal value and
        to specify the type of the observable property.
    
    */
    public func observe<T>(keyPath path: String, value: T) -> KVOSignal<T> {
        
        let signal = KVOSignal<T>(subject: self, keyPath: path)
        
        signal.dispatch(value)
        
        return signal
    }
}
