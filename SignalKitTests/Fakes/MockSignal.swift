//
//  MockSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class MockSignal<T>: SignalType {
    public typealias Item = T
    
    public var disposableSource: Disposable?
    public let dispatcher: ObserversDispatcher<Item>
    
    public init(lock: LockType? = nil) {
        
        dispatcher = ObserversDispatcher<Item>(lock: lock)
    }
}
