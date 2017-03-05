//
//  UISegmentedControlExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UISegmentedControl {
    
    /// Observe selected index in UISegmentedControl
    
    public var selectedIndex: Signal<Int> {
        
        return events(.valueChanged).map { $0.selectedSegmentIndex }
    }
}
