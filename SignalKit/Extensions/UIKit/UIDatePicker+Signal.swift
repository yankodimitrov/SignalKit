//
//  UIDatePicker+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UIDatePicker {
    
    /**
        Observe for date changes
    
    */
    public var date: Signal<NSDate> {
        
        let signal = ControlSignal(control: sender, events: .ValueChanged).map { $0.date }
        
        signal.dispatch(sender.date)
        
        return signal
    }
}
