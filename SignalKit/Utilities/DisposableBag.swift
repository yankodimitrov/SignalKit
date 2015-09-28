//
//  DisposableBag.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class DisposableBag {
    
    private lazy var bag = Bag<Disposable>()
    
    internal var count: Int {
        return bag.count
    }
    
    public init() {}
    
    public func addDisposable(disposable: Disposable) -> Disposable {
        
        let token = self.bag.insert(disposable)
        
        return DisposableAction { [weak self] in
            
            self?.bag.removeItemWithToken(token)
        }
    }
    
    public func removeAll() {
        
        bag.removeItems()
    }
}
