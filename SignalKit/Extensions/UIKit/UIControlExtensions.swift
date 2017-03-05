//
//  UIControlExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UIControl {
    
    /// Observe for control events
    
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
    
    /// Observe the confrol for TouchUpInside events
    
    public var tapEvent: Signal<Sender> {
        
        return events(.touchUpInside)
    }
}

public extension SignalType where Value == Bool {
    
    /// Bind the boolean value of the signal to the enabled property of UIControl
    
    public func bindTo(enabledStateIn control: UIControl) -> Self {
        
        addObserver { [weak control] in
            
            control?.isEnabled = $0
        }
        
        return self
    }
}
