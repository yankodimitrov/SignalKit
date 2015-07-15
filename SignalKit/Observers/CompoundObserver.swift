//
//  CompoundObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class CompoundObserver<T: Observable, U: Observable>: Disposable {
    
    private let signalA: T
    private let signalB: U
    private let callback: ((T.Item, U.Item)) -> Void
    
    private var observerA: ObserverOf<T>?
    private var observerB: ObserverOf<U>?
    
    private var latestValueA: T.Item?
    private var latestValueB: U.Item?
    
    init(signalA: T, signalB: U, callback: ((T.Item, U.Item)) -> Void) {
        
        self.signalA = signalA
        self.signalB = signalB
        self.callback = callback
        
        observeSignal(signalA, andSignal: signalB)
    }
    
    deinit {
        
        dispose()
    }
    
    private func observeSignal(a: T, andSignal b: U) {
        
        observerA = ObserverOf<T>(observe: signalA) { [weak self] in
            
            self?.dispatchLatest(valueA: $0, valueB: nil)
        }
        
        observerB = ObserverOf<U>(observe: signalB) { [weak self] in
            
            self?.dispatchLatest(valueA: nil, valueB: $0)
        }
    }
    
    private func dispatchLatest(#valueA: T.Item?, valueB: U.Item?) {
        
        if let a = valueA {
            
            latestValueA = a
        }
        
        if let b = valueB {
            
            latestValueB = b
        }
        
        if let a = latestValueA, let b = latestValueB {
            
            callback( (a, b) )
        }
    }
    
    func dispose() {
        
        latestValueA = nil
        latestValueB = nil
        
        observerA?.dispose()
        observerB?.dispose()
    }
}
