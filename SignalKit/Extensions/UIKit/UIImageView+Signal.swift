//
//  UIImageView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where ObservationType == UIImage? {
    
    /**
        Bind a UIImage to the image property of UIImageView
    
    */
    public func bindTo(imageIn imageView: UIImageView) -> Self {
        
        addObserver { [weak imageView] in
            
            imageView?.image = $0
        }
        
        return self
    }
}
