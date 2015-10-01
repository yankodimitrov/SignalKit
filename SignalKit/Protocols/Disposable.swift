//
//  Disposable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Disposable {
    
    func dispose()
}

public extension Disposable {
    
    /**
        Stores a disposable in a container
    
    */
    public func addTo(container: DisposableBag) -> Disposable {
        
        return container.addDisposable(self)
    }
}
