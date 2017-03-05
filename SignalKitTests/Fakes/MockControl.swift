//
//  MockControl.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

class MockControl: UIControl {
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if let target = target as? NSObject {
            
            target.perform(action, with: nil)
        }
    }
}

class MockDatePicker: UIDatePicker {
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, for: event)
    }
}

class MockSegmentedControl: UISegmentedControl {
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, for: event)
    }
}

class MockSlider: UISlider {
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, for: event)
    }
}

class MockSwitch: UISwitch {
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, for: event)
    }
}

class MockTextField: UITextField {
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, for: event)
    }
}
