//
//  ObservableCollectionType.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/20/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol ObservableCollectionType {
    
    var changeSetSignal: Signal<CollectionChangeSet> { get }
}

extension ObservableCollectionType {
    
    public func observe() -> SignalEvent<Self> {
        
        return SignalEvent(sender: self)
    }
}
