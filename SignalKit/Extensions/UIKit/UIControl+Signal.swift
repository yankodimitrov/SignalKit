//
//  UIControl+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/15/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UIControl {
    
    /**
        Observe for control events
    
    */
    public func events(controlEvents: UIControlEvents) -> ControlSignal<Sender> {
        
        return ControlSignal(control: sender, events: controlEvents)
    }
}

public extension SignalType where Item == Bool {
    
    /**
        Bind the Boolean value of the signal to the enabled property of UIControl
    
    */
    public func bindTo(enabled control: UIControl) -> Self {
        
        addObserver { [weak control] in
            
            control?.enabled = $0
        }
        
        return self
    }
}
