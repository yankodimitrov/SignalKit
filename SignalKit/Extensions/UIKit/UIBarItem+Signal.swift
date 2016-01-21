//
//  UIBarItem+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where ObservationType == Bool {
    
    /**
        Bind the Boolean value of the signal to the enabled property of UIBarItem
     
     */
    public func bindTo(enabled barItem: UIBarItem) -> Self {
        
        addObserver { [weak barItem] in
            
            barItem?.enabled = $0
        }
        
        return self
    }
}
