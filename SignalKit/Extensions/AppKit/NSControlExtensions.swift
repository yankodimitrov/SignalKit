//
//  NSControlExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/17.
//  Copyright © 2017 Yanko Dimitrov. All rights reserved.
//

import AppKit

public extension Event where Sender: NSControl {
    
    /// Observe for control event
    public var controlEvent: Signal<Sender> {
        
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

public extension SignalProtocol where Value == Bool {
    
    /// Bind the Bool value of the Signal to the isEnabled property of NSControl.
    ///
    /// - Parameter control: The NSControl to update.
    /// - Returns: Signal of the same type.
    public func bindTo(enabledStateIn control: NSControl) -> Self {
        
        addObserver { [weak control] in
            
            control?.isEnabled = $0
        }
        
        return self
    }
}
