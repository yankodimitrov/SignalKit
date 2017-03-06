//
//  UIViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalProtocol where Value == CGFloat {
    
    /// Bind the CGFloat value of the Signal to the alpha property of UIView.
    ///
    /// - Parameter view: The UIView to update.
    /// - Returns: Signal of the same type.
    public func bindTo(alphaIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.alpha = $0
        }
        
        return self
    }
}

public extension SignalProtocol where Value == Bool {
    
    /// Bind the Bool value of the Signal to the isHidden property of UIView.
    ///
    /// - Parameter view: The UIView to update.
    /// - Returns: Signal of the same type.
    public func bindTo(hiddenStateIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.isHidden = $0
        }
        
        return self
    }
}
