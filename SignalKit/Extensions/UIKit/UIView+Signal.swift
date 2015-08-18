//
//  UIView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where Item == UIColor {
    
    /**
        Bind a UIColor to the background color of UIView
    
    */
    public func bindTo(backgroundColorIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.backgroundColor = $0
        }
        
        return self
    }
}

public extension SignalType where Item == CGFloat {
    
    /**
       Bind a CGFloat value to the alpha property of UIView
    
    */
    public func bindTo(alphaIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.alpha = $0
        }
        
        return self
    }
}

public extension SignalType where Item == Bool {
    
    /**
        Bind a Boolean value to the hidden property of UIView
    
    */
    public func bindTo(hiddenStateIn view: UIView) -> Self {
        
        addObserver { [weak view] in
            
            view?.hidden = $0
        }
        
        return self
    }
}
