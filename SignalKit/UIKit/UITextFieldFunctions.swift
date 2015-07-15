//
//  UITextFieldFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe the text in UITextField

*/
public func observe(textIn field: UITextField) -> Signal<String> {
    
    let signal = observe(field, forEvents: .EditingChanged).map { $0.text ?? "" }
    
    signal.dispatch(field.text ?? "")
    
    return signal
}

/**
    Bind a String value to the text property of UITextField

*/
public func textIn(field: UITextField) -> String -> Void {
    
    return { [weak field] text in
        
        field?.text = text
    }
}

/**
    Bind a NSAttributedString to the attributedText property of UITextField

*/
public func attributedTextIn(field: UITextField) -> NSAttributedString -> Void {
    
    return { [weak field] text in
        
        field?.attributedText = text
    }
}
