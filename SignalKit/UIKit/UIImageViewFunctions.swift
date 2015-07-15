//
//  UIImageViewFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Bind a UIImage to the image property of UIImageView

*/
public func imageIn(imageView: UIImageView) -> UIImage? -> Void {
    
    return { [weak imageView] image in
        
        imageView?.image = image
    }
}
