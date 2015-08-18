//
//  SignalBag.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class SignalBag: SignalContainerType {
    
    private lazy var bag = Bag<Disposable>()
    
    internal var signalsCount: Int {
        return bag.count
    }
    
    public init() {}
    
    public func addSignal<T: SignalType>(signal: T) -> Disposable {
        
        let token = self.bag.insert(signal)
        
        return DisposableAction { [weak self] in
            
            self?.bag.removeItemWithToken(token)
        }
    }
    
    public func removeSignals() {
        
        bag.removeItems()
    }
}
