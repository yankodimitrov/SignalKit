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
    
    private let notificationName: String
    private weak var object: AnyObject?
    private var isDisposed = false
    
    private var center: NSNotificationCenter {
        return  NSNotificationCenter.defaultCenter()
    }
    
    public var disposableSource: Disposable?
    public let dispatcher: ObserversDispatcher<Item>
    
    public init(notificationName: String, fromObject object: AnyObject? = nil, lock: LockType? = nil) {
        
        self.dispatcher = ObserversDispatcher<Item>(dispatchRule: { _ in return { return nil }}, lock: lock)
        self.notificationName = notificationName
        self.object = object
        
        super.init()
        
        center.addObserver(self, selector: "notificationHandler:", name: notificationName, object: object)
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
