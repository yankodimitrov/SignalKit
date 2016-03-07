//
//  UIImageViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalType where ObservationValue == UIImage? {
    
    /// Bind the a UIImage to the image property of UIImageView
    
    public func bindTo(imageIn imageView: UIImageView) -> Self {
        
        addObserver { [weak imageView] in
            
            imageView?.image = $0
        }
        
        return self
    }
}
