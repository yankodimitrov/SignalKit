//
//  UIDatePickerExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UIDatePicker {
    
    /// Observe date changes in UIDatePicker
    
    public var date: Signal<Date> {
        
        return events(.valueChanged).map { $0.date }
    }
}
