//
//  SignalList.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class SignalBag: SignalContainerType {
    
    private lazy var signals = Bag<SignalType>()
    private let lock: LockType?
    
    internal var signalsCount: Int {
        return signals.count
    }
    
    public init(lock: LockType? = nil) {
        
        self.lock = lock
    }
    
    public func addSignal(signal: SignalType) -> Disposable {
        
        lock?.lock()
        
        let token = signals.insert(signal)
        
        lock?.unlock()
        
        return DisposableItem { [weak self] in
            
            self?.lock?.lock()
            
            self?.signals.removeItemWithToken(token)
            
            self?.lock?.unlock()
        }
    }
    
    public func removeSignals() {
        
        lock?.lock()
        
        signals.removeItems()
        
        lock?.unlock()
    }
}
