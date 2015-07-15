//
//  UIControlFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/// MARK: Observe

/**
    Observe UIControl for UIControlEvents

*/
public func observe<T: UIControl>(control: T, forEvents events: UIControlEvents, callback: (T -> Void)? = nil) -> Signal<T> {
    
    let signal = Signal<T>(dispatchRule: { (v: T) in return { [weak v] in return v} })
    
    let observer = ControlObserver(observe: control, events: events) { [weak signal] in
        
        signal?.dispatch($0)
    }
    
    if let callback = callback {
        
        signal.addObserver(callback)
    }
    
    signal.addDisposable(observer)
    
    return signal
}

/// MARK: Bind

/**
    Bind a Boolean value to the enabled state of UIControl

*/
public func isEnabled(control: UIControl) -> Bool -> Void {
    
    return { [weak control] enabled in
        
        control?.enabled = enabled
    }
}
