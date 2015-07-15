//
//  UILabelFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Bind a String value to the text property of UILabel

*/
public func textIn(label: UILabel) -> String -> Void {
    
    return { [weak label] text in
        
        label?.text = text
    }
}

/**
    Bind a NSAttributedString to the attributedText property of UILabel

*/
public func attributedTextIn(label: UILabel) -> NSAttributedString -> Void {
    
    return { [weak label] text in
        
        label?.attributedText = text
    }
}
