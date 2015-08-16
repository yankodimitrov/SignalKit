//
//  UISegmentedControl+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UISegmentedControl {
    
    /**
        Observe the selected segment index changes in UISegmentedControl
    
    */
    public var selectedIndex: Signal<Int> {
        
        return ControlSignal(control: sender, events: .ValueChanged).map { $0.selectedSegmentIndex }
    }
}
