//
//  UIControlExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UIControl {
    
    /// Observe for UIControl events.
    ///
    /// - Parameter events: UIControlEvents to observe for.
    /// - Returns: Signal with the type of the UIControl.
    public func events(_ events: UIControlEvents) -> Signal<Sender> {
        
        let signal = Signal<Sender>()
        let observer = ControlEventObserver(control: sender, events: events)
        
        observer.eventCallback = { [weak signal] control in
            
            if let control = control as? Sender {
                
                signal?.send(control)
            }
        }
        
        signal.disposableSource = observer
        
        return signal
    }
    
    /// Observe the confrol for TouchUpInside events.
    public var tapEvent: Signal<Sender> {
        
        return events(.touchUpInside)
    }
}

public extension SignalProtocol where Value == Bool {
    
    /// Bind the Bool value of the Signal to the isEnabled property of UIControl.
    ///
    /// - Parameter control: The UIControl to update.
    /// - Returns: Signal of the same type.
    public func bindTo(enabledStateIn control: UIControl) -> Self {
        
        addObserver { [weak control] in
            
            control?.isEnabled = $0
        }
        
        return self
    }
}
