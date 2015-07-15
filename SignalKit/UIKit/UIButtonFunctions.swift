//
//  UIButtonFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe for TouchUpInside event in UIButton

*/
public func observe(touchUpInside button: UIButton) -> Signal<UIButton> {
    
    return observe(button, forEvents: .TouchUpInside)
}
