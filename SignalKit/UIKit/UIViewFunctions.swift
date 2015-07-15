//
//  UIViewFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Bind a UIColor to the backgroundColor of UIView

*/
public func backgroundColorIn(view: UIView) -> UIColor -> Void {
    
    return { [weak view] color in
        
        view?.backgroundColor = color
    }
}

/**
    Bind a CGFloat value to the alpha property of UIView

*/
public func alphaIn(view: UIView) -> CGFloat -> Void {
    
    return { [weak view] alpha in
        
        view?.alpha = alpha
    }
}

/**
    Bind a Boolean value to the hidden property of UIView

*/
public func viewIsHidden(view: UIView) -> Bool -> Void {
    
    return { [weak view] hidden in
        
        view?.hidden = hidden
    }
}
