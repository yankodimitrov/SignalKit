//
//  UIImageViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalProtocol where Value == UIImage? {
    
    /// Bind the UIImage value of the Signal to the image property of UIImageView.
    ///
    /// - Parameter imageView: The UIImageView to update.
    /// - Returns: Signal of the same type.
    public func bindTo(imageIn imageView: UIImageView) -> Self {
        
        addObserver { [weak imageView] in
            
            imageView?.image = $0
        }
        
        return self
    }
}
