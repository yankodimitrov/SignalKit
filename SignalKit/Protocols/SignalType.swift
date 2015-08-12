//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: class, Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

public extension SignalType {
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
    
    /**
        Add a new observer to a signal to perform a side effect
    
    */
    public func next(observer: Item -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
    
    /**
        Transform a signal ot type Item to a signal of type U
    
    */
    public func map<U>(transform: Item -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.dispatch( transform($0) )
        }
        
        signal.disposableSource = self
        
        return signal
    }
}
