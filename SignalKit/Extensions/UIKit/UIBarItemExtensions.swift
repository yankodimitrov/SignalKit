//
//  UIBarItemExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalProtocol where Value == Bool {
    
    /// Bind the Bool value of the Signal to the isEnabled property of UIBarItem
    ///
    /// - Parameter barItem: The UIBarItem to update.
    /// - Returns: Signal of the same type.
    public func bindTo(enabledStateIn barItem: UIBarItem) -> Self {
        
        addObserver { [weak barItem] in
            
            barItem?.isEnabled = $0
        }
        
        return self
    }
}
