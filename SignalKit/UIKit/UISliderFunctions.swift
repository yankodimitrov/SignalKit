//
//  UISliderFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe UISlider for value change

*/
public func observe(valueIn slider: UISlider) -> Signal<Float> {
    
    let signal = observe(slider, forEvents: .ValueChanged).map { $0.value }
    
    signal.dispatch(slider.value)
    
    return signal
}

/**
    Bind a Float value to the value property of UISlider

*/
public func valueIn(slider: UISlider) -> Float -> Void {
    
    return { [weak slider] value in
        
        slider?.value = value
    }
}
