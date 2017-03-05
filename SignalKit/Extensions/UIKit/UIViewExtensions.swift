//
//  UIViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalProtocol where Value == CGFloat {
    
    /// Bind a CGFloat value to the alpha property of UIView
    
    public func bindTo(alphaIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.alpha = $0
        }
        
        return self
    }
}

public extension SignalProtocol where Value == Bool {
    
    /// Bind a boolean value to the hidden property of UIView
    
    public func bindTo(hiddenStateIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.isHidden = $0
        }
        
        return self
    }
}
