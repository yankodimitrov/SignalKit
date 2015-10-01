//
//  UISlider+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UISlider {
    
    /**
        Observe the value changes in UISlider
    
    */
    public var valueChanges: Signal<Float> {
        
        let signal = ControlSignal(control: sender, events: .ValueChanged).map { $0.value }
        
        signal.dispatch(sender.value)
        
        return signal
    }
}

public extension SignalType where ObservationType == Float {
    
    /**
        Bind a Float to the value property of UISlider
    
    */
    public func bindTo(valueIn slider: UISlider) -> Self {
        
        addObserver { [weak slider] in
            
            slider?.value = $0
        }
        
        return self
    }
}
