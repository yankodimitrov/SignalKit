//
//  UILabelExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where Value == String {
    
    /// Bind a string value to the text property of UILabel
    
    public func bindTo(textIn label: UILabel) -> Self {
        
        addObserver { [weak label] in
            
            label?.text = $0
        }
        
        return self
    }
}
