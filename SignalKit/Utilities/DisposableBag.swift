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
    
    public init() {}
    
    public func addDisposable(disposable: Disposable) -> Disposable {
        
        let token = self.bag.insert(disposable)
        
        return DisposableAction { [weak self] in
            
            self?.bag.removeItemWithToken(token)
        }
    }
    
    deinit {
        
        removeAll()
    }
    
    public func removeAll() {
        
        for (_, disposableItem) in bag {
            
            disposableItem.dispose()
        }
        
        bag.removeItems()
    }
}

extension DisposableBag {
    
    internal var count: Int {
        
        return bag.count
    }
}

extension DisposableBag: Disposable {
    
    public func dispose() {
        
        removeAll()
    }
}
