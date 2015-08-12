//
//  ControlSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ControlSignal<T: UIControl>: NSObject, SignalType {
    public typealias Item = T
    
    private weak var control: T?
    private let events: UIControlEvents
    private var isDisposed = false
    
    public var disposableSource: Disposable?
    public let dispatcher: ObserversDispatcher<Item>
    
    public init(control: T, events: UIControlEvents, lock: LockType? = nil) {
        
        self.dispatcher = ObserversDispatcher<Item>(lock: lock)
        self.control = control
        self.events = events
        
        super.init()
        
        control.addTarget(self, action: "eventHandler", forControlEvents: events)
    }
    
    deinit {
        
        dispose()
    }
    
    public func eventHandler() {
        
        if let control = control {
            
            dispatch(control)
        }
    }
    
    public func dispose() {
    
        guard !isDisposed else { return }
        
        control?.removeTarget(self, action: "eventHandler", forControlEvents: events)
        isDisposed = true
        
        disposableSource?.dispose()
    }
}
