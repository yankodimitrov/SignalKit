//
//  NSNotificationCenterExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public extension SignalEventType where Sender: NSNotificationCenter {
    
    /// Observe the notification center for a given notification
    
    public func notification(name: String, fromObject: AnyObject? = nil) -> Signal<NSNotification> {
        
        let signal = Signal<NSNotification>()
        let observer = NotificationObserver(center: sender, name: name, object: fromObject)
        
        observer.notificationCallback = { [weak signal] in
            
            signal?.sendNext($0)
        }
        
        signal.disposableSource = observer
        
        return signal
    }
}
