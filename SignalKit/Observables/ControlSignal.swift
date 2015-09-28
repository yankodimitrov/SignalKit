//
//  ControlSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class ControlSignal<T: UIControl>: SignalType {
    
    public typealias Item = T
    public var disposableSource: Disposable?
    public let dispatcher: Dispatcher<Item>
    
    private weak var control: T?
    private let observer: ControlObserver
    
    public init(control: T, events: UIControlEvents, lock: LockType? = nil) {
        
        self.dispatcher = Dispatcher<Item>(dispatchRule: {(v: T) in return { [weak v] in return v} }, lock: lock)
        self.control = control
        self.observer = ControlObserver(control: control, events: events)
        
        observer.callback = { [weak self] in
            
            if let control = self?.control {
                self?.dispatch(control)
            }
        }
    }
    
    deinit {
        
        dispose()
    }
    
    public func dispose() {
        
        observer.dispose()
        disposableSource?.dispose()
    }
}

internal final class ControlObserver: NSObject, Disposable {
    
    private weak var control: UIControl?
    private let events: UIControlEvents
    private var isDisposed = false
    private var callback: (() -> Void)?
    
    init(control: UIControl, events: UIControlEvents) {
        
        self.control = control
        self.events = events
        
        super.init()
        
        control.addTarget(self, action: "eventHandler", forControlEvents: events)
    }
    
    func eventHandler() {
        
        callback?()
    }
    
    func dispose() {
        
        guard !isDisposed else { return }
        
        control?.removeTarget(self, action: "eventHandler", forControlEvents: events)
        isDisposed = true
    }
}
