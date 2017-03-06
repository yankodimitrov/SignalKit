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
    
    /// Store a Disposable item in a bag.
    /// When the bag is disposed it will dispose all items that are stored inside.
    ///
    /// Usually used to store a chain of Signal operations in a DisposableBag.
    ///
    /// - Parameter bag: The DisposableBag to store the item in.
    /// - Returns: Disposable item which can be used to remove the item from the bag.
    @discardableResult public func disposeWith(_ bag: DisposableBag) -> Disposable {
        
        return bag.insert(self)
    }
}
