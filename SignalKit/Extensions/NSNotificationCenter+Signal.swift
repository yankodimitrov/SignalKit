//
//  NSNotificationCenter+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public extension NSNotificationCenter {
    
    /**
        Returns all available events for this type.
    
    */
    public func observe() -> SignalEvent<NSNotificationCenter> {
        
        return SignalEvent(sender: self)
    }
}

public extension SignalEventType where Sender == NSNotificationCenter {
    
    /**
        Observes the notification center for a given notification.
    
    */
    public func notification(name: String, fromObject: AnyObject? = nil) -> NotificationSignal {
        
        return NotificationSignal(notificationName: name, fromObject: fromObject)
    }
}
