//
//  Functions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

/// MARK: - Observe

/**
    Observe any Observable type

*/
public func observe<T: Observable>(observable: T, callback: (T.Item -> Void)? = nil) -> Signal<T.Item> {
    
    let signal = Signal<T.Item>(lock: SpinLock())
    
    let observer = ObserverOf<T>(observe: observable) { [weak signal] in
        
        signal?.dispatch($0)
    }
    
    if let callback = callback {
        
        signal.addObserver(callback)
    }
    
    signal.addDisposable(observer)
    
    return signal
}
