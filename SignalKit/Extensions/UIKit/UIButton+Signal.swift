//
//  UIButton+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UIButton {
    
    /**
        Observe the button for TouchUpInside events
    
    */
    public var tapEvent: ControlSignal<Sender> {
        
        return ControlSignal(control: sender, events: .TouchUpInside)
    }
}
