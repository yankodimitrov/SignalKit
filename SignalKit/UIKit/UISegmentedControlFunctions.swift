//
//  UISegmentedControlFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/16/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe the selected segment index in UISegmentedControl

*/
public func observe(selectedIndexIn segmentedControl: UISegmentedControl) -> Signal<Int> {
    
    let signal = observe(segmentedControl, forEvents: .ValueChanged).map { $0.selectedSegmentIndex }
    
    signal.dispatch(segmentedControl.selectedSegmentIndex)
    
    return signal
}
