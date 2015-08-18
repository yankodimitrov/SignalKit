//
//  UITextField+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UITextField {
    
    /**
        Observe the text changes in UITextField
    
    */
    public var text: Signal<String> {
        
        let signal = ControlSignal(control: sender, events: .EditingChanged).map { $0.text ?? "" }
        
        signal.dispatch(sender.text ?? "")
        
        return signal
    }
}
