//
//  UILabelExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalProtocol where Value == String {
    
    /// Bind the String value of the Signal to the text property of UILabel.
    ///
    /// - Parameter label: the UILabel to update.
    /// - Returns: Signal of the same type.
    public func bindTo(textIn label: UILabel) -> Self {
        
        addObserver { [weak label] in
            
            label?.text = $0
        }
        
        return self
    }
}
