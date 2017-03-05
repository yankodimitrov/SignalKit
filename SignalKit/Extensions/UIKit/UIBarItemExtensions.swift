//
//  UIBarItemExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where ObservationValue == Bool {
    
    /// Bind the boolean value of the signal to the enabled property of UIBarItem
    
    public func bindTo(enabledStateIn barItem: UIBarItem) -> Self {
        
        addObserver { [weak barItem] in
            
            barItem?.isEnabled = $0
        }
        
        return self
    }
}
