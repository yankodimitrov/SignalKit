//
//  MockControl.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

class MockControl: UIControl {
    
    override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        if let target = target as? NSObject {
            
            target.performSelector(action, withObject: nil)
        }
    }
}

class MockDatePicker: UIDatePicker {
    
    override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, forEvent: event)
    }
}

class MockSegmentedControl: UISegmentedControl {
    
    override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        let control = MockControl()
        
        control.sendAction(action, to: target, forEvent: event)
    }
}
