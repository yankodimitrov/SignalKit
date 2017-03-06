//
//  UIBarButtonItemExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UIBarButtonItem {
    
    /// Observe for tap events in UIBarButtonItem.
    public var tapEvent: Signal<Sender> {
        
        let signal = Signal<Sender>()
        let target = ActionTarget()
        
        target.actionCallback = { [weak signal] sender in
            
            guard let sender = sender as? Sender else { return }
            
            signal?.send(sender)
        }
        
        sender.target = target
        sender.action = #selector(target.handleAction)
        
        signal.disposableSource = target
        
        return signal
    }
}
