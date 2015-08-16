//
//  NotificationSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class NotificationSignal: NSObject, SignalType {
    public typealias Item = NSNotification
    
    private let center: NSNotificationCenter
    private let notificationName: String
    private weak var object: AnyObject?
    private var isDisposed = false
    
    public var disposableSource: Disposable?
    public let dispatcher: Dispatcher<Item>
    
    public init(center: NSNotificationCenter, name: String, fromObject object: AnyObject? = nil, lock: LockType? = nil) {
        
        self.center = center
        self.dispatcher = Dispatcher<Item>(dispatchRule: { _ in return { return nil }}, lock: lock)
        self.notificationName = name
        self.object = object
        
        super.init()
        
        center.addObserver(self, selector: "notificationHandler:", name: notificationName, object: object)
    }
    
    /**
        Initialzie with default notification center
    
    */
    public convenience init(name: String, fromObject: AnyObject? = nil, lock: LockType? = nil) {
        
        let center = NSNotificationCenter.defaultCenter()
        
        self.init(center: center, name: name, fromObject: fromObject, lock: lock)
    }
    
    deinit {
        
        dispose()
    }
    
    public func notificationHandler(notification: NSNotification) {
        
        dispatch(notification)
    }
    
    public func dispose() {
        
        guard !isDisposed else { return }
        
        center.removeObserver(self, name: notificationName, object: object)
        object = nil
        isDisposed = true
        
        disposableSource?.dispose()
    }
}
