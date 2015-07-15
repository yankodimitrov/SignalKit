//
//  UIDatePickerFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe UIDatePicker for date changes

*/
public func observe(dateIn datePicker: UIDatePicker) -> Signal<NSDate> {
    
    let signal = observe(datePicker, forEvents: .ValueChanged).map { $0.date }
    
    signal.dispatch(datePicker.date)
    
    return signal
}
