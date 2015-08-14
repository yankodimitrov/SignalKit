//
//  CompoundObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/14/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

internal final class CompoundObserver<T: Observable, U: Observable>: Disposable {
    
    private let observableA: T
    private let observableB: U
    
    private var latestA: T.Item?
    private var latestB: U.Item?
    private var subscriptionA: Disposable?
    private var subscriptionB: Disposable?
    
    private let callback: ((T.Item, U.Item)) -> Void
    
    init(observableA: T, observableB: U, callback: ( (T.Item, U.Item) ) -> Void) {
        
        self.observableA = observableA
        self.observableB = observableB
        self.callback = callback
        
        observe()
    }
    
    deinit {
        
        dispose()
    }
    
    private func observe() {
        
        subscriptionA = observableA.addObserver { [weak self] in
            
            self?.latestA = $0
            self?.dispatchLatest()
        }
        
        subscriptionB = observableB.addObserver { [weak self] in
            
            self?.latestB = $0
            self?.dispatchLatest()
        }
    }
    
    private func dispatchLatest() {
        
        if let a = latestA, b = latestB {
            
            callback( (a, b) )
        }
    }
    
    func dispose() {
        
        subscriptionA?.dispose()
        subscriptionB?.dispose()
        
        latestA = nil
        latestB = nil
    }
}
