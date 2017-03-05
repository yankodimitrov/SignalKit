//
//  UIBarButtonItemExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UIBarButtonItem {
    
    /// Observe the tap action in UIBarButtonItem
    
    public var tapEvent: Signal<AnyObject> {
        
        let signal = Signal<AnyObject>()
        let target = ActionTarget()
        
        target.actionCallback = { [weak signal] sender in
            
            signal?.send(sender)
        }
        
        sender.target = target
        sender.action = #selector(target.handleAction)
        
        signal.disposableSource = target
        
        return signal
    }
}
