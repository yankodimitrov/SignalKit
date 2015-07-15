//
//  ObserverOf.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class ObserverOf<T: Observable>: Disposable {
    
    private let callback: T.Item -> Void
    private var subscription: Disposable?
    
    init(observe observable: T, callback: T.Item -> Void) {
        
        self.callback = callback
        
        subscription = observable.addObserver { [weak self] in
            
            self?.callback($0)
        }
    }
    
    deinit {
        
        dispose()
    }
    
    func dispose() {
        
        subscription?.dispose()
        subscription = nil
    }
}
