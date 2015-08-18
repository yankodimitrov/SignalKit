//
//  UISwitch+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UISwitch {
    
    /**
        Observe the on state changes in UISwitch
    
    */
    public var onState: Signal<Bool> {
        
        let signal = ControlSignal(control: sender, events: .ValueChanged).map { $0.on }
        
        signal.dispatch(sender.on)
        
        return signal
    }
}

public extension SignalType where Item == Bool {
    
    /**
        Bind a Bool to the on state of UISwitch
    
    */
    public func bindTo(onStateIn switchControl: UISwitch) -> Self {
        
        addObserver { [weak switchControl] in
            
            switchControl?.on = $0
        }
        
        return self
    }
}
