//
//  NotificationObserver.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class NotificationObserver: NSObject, Disposable {
    
    private let notification: String
    private let callback: NSNotification -> Void
    private var disposed = false
    
    private var center: NSNotificationCenter {
        return  NSNotificationCenter.defaultCenter()
    }
    
    init(observe notification: String, fromObject object: AnyObject?, callback: NSNotification -> Void) {
        
        self.notification = notification
        self.callback = callback
        
        super.init()
        
        center.addObserver(self, selector: "notificationHandler:", name: notification, object: object)
    }
    
    convenience init(observe notification: String, callback: NSNotification -> Void) {
        
        self.init(observe: notification, fromObject: nil, callback: callback)
    }
    
    deinit {
        
        dispose()
    }
    
    func notificationHandler(notification: NSNotification) {
        
        callback(notification)
    }
    
    func dispose() {
        
        if disposed {
            return
        }
        
        center.removeObserver(self, name: notification, object: nil)
        disposed = true
    }
}
