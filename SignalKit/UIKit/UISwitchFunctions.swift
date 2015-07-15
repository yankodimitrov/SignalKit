//
//  UISwitchFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe UISwitch for on/off state changes

*/
public func observe(switchIsOn switchControl: UISwitch) -> Signal<Bool> {
    
    let signal = observe(switchControl, forEvents: .ValueChanged).map { $0.on }
    
    signal.dispatch(switchControl.on)
    
    return signal
}

/**
    Bind a Boolean value to the on/off state of UISwitch

*/
public func switchIsOn(switchControl: UISwitch) -> Bool -> Void {
    
    return { [weak switchControl] state in
        
        switchControl?.on = state
    }
}
