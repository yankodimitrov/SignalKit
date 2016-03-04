//
//  SignalType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol SignalType: Observable, Disposable {
    
    var disposableSource: Disposable? {get set}
}

// MARK: - Disposable

extension SignalType {
    
    public func dispose() {
        
        disposableSource?.dispose()
    }
}

// MARK: - Next

extension SignalType {
    
    /// Adds a new observer to a Signal
    
    public func next(observer: ObservationValue -> Void) -> Self {
        
        addObserver(observer)
        
        return self
    }
}

// MARK: - Map

extension SignalType {
    
    /// Transform a Signal of type ObservationValue to a Signal of type U
    
    public func map<U>(transform: ObservationValue -> U) -> Signal<U> {
        
        let signal = Signal<U>()
        
        addObserver { [weak signal] in
            
            signal?.sendNext(transform($0))
        }
        
        signal.disposableSource = self
        
        return signal
    }
}
