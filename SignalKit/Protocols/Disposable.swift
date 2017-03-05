//
//  Disposable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Disposable {
    
    func dispose()
}

// MARK: - DisposeWith

extension Disposable {
    
    /// Store a chain of signal operations in a DisposableBag and dispose the chain with the bag
    
    public func disposeWith(_ bag: DisposableBag) -> Disposable {
        
        return bag.insertItem(self)
    }
}
