//
//  NotificationSignal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class NotificationSignal: SignalType {
    
    public typealias Item = NSNotification
    public var disposableSource: Disposable?
    public let dispatcher: Dispatcher<Item>
    
    private let observer: NotificationObserver
    
    public init(center: NSNotificationCenter, name: String, fromObject object: AnyObject? = nil, lock: LockType? = nil) {
        
        dispatcher = Dispatcher<Item>(dispatchRule: { _ in return { return nil }}, lock: lock)
        observer = NotificationObserver(center: center, name: name, fromObject: object)
        
        observer.callback = { [weak self] notification in
            
            self?.dispatch(notification)
        }
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
    
    public func dispose() {
        
        observer.dispose()
        disposableSource?.dispose()
    }
}

internal final class NotificationObserver: NSObject, Disposable {
    
    private let center: NSNotificationCenter
    private let notificationName: String
    private weak var object: AnyObject?
    private var isDisposed = false
    
    internal var callback: ((notification: NSNotification) -> Void)?
    
    init(center: NSNotificationCenter, name: String, fromObject object: AnyObject? = nil) {
        
        self.center = center
        self.object = object
        self.notificationName = name
        
        super.init()
        
        center.addObserver(self, selector: "notificationHandler:", name: notificationName, object: object)
    }
    
    func notificationHandler(notification: NSNotification) {
        
        callback?(notification: notification)
    }
    
    func dispose() {
        guard !isDisposed else { return }
        
        center.removeObserver(self, name: notificationName, object: object)
        object = nil
        isDisposed = true
    }
}
