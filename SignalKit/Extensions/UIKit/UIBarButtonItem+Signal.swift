//
//  UIBarButtonItem+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UIBarButtonItem {
    
    public var tapEvent: Signal<AnyObject> {
        
        let signal = Signal<AnyObject>()
        
        let disposableTarget = DisposableActionTarget { [weak signal] in
            
            signal?.dispatch($0)
        }
        
        sender.target = disposableTarget
        sender.action = disposableTarget.actionSelector
        
        signal.disposableSource = disposableTarget
        
        return signal
    }
}
