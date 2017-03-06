//
//  NSNotificationCenterExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public extension Event where Sender: NotificationCenter {
    
    /// Observe for a given notification.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - fromObject: The sender of the notification
    /// - Returns: Signal<Notification>
    public func notification(_ name: Notification.Name, fromObject: AnyObject? = nil) -> Signal<Notification> {
        
        let signal = Signal<Notification>()
        let observer = NotificationObserver(center: sender, name: name, object: fromObject)
        
        observer.notificationCallback = { [weak signal] in
            
            signal?.send($0)
        }
        
        signal.disposableSource = observer
        
        return signal
    }
}
