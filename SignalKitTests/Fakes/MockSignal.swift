//
//  MockSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
@testable import SignalKit

public final class MockSignal<T>: SignalType {
    public typealias Item = T
    
    public var disposableSource: Disposable?
    public let dispatcher: Dispatcher<Item>
    
    internal var isDisposeCalled = false
    
    public init(lock: LockType? = nil) {
        
        dispatcher = Dispatcher<Item>(lock: lock)
    }
    
    public func dispose() {
        isDisposeCalled = true
    }
}

public final class DummySignal<T>: SignalType {
    public typealias Item = T
    
    public var disposableSource: Disposable?
    public let dispatcher: Dispatcher<Item>
    
    internal var isDisposeCalled = false
    
    public init(lock: LockType? = nil) {
        
        dispatcher = Dispatcher<Item>(lock: lock)
    }
}