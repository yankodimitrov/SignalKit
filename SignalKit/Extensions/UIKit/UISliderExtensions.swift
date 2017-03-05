//
//  UISliderExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UISlider {
    
    /// Observe value changes in UISlider
    
    public var valueChanges: Signal<Float> {
        
        return events(.valueChanged).map { $0.value }
    }
}
