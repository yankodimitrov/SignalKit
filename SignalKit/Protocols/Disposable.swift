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
    
    /// Store a chain of Signal operations in a DisposableBag.
    /// The chain will be released when the bag disposes.
    ///
    /// - Parameter bag: The DisposableBag in which to store the chain of Signal operations.
    /// - Returns: Disposable which can be used to remove the chain from the bag.
    @discardableResult public func disposeWith(_ bag: DisposableBag) -> Disposable {
        
        return bag.insert(self)
    }
}
