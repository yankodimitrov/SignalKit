//
//  UITextViewFunctions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

/**
    Observe the text in UITextView

*/
public func observe(textIn textView: UITextView) -> Signal<String> {
    
    let notificationSignal = observe(UITextViewTextDidChangeNotification, fromObject: textView)
    
    let signal = notificationSignal.map { [weak textView] _ in
        
        textView?.text ?? ""
    }
    
    signal.dispatch(textView.text ?? "")
    
    return signal
}

/**
    Observe the attributed text in UITextView

*/
public func observe(attributedTextIn textView: UITextView) -> Signal<NSAttributedString> {
    
    let notificationSignal = observe(UITextViewTextDidChangeNotification, fromObject: textView)
    
    let signal = notificationSignal.map { [weak textView] _ in
        
        textView?.attributedText ?? NSAttributedString(string: "")
    }
    
    signal.dispatch(textView.attributedText ?? NSAttributedString(string: ""))
    
    return signal
}

/**
    Bind a String value to the text property of UITextView

*/
public func textIn(textView: UITextView) -> String -> Void {
    
    return { [weak textView] text in
        
        textView?.text = text
    }
}

/**
    Bind a NSAttributedString to the attributedText property of UITextView

*/
public func attributedTextIn(textView: UITextView) -> NSAttributedString -> Void {
    
    return { [weak textView] text in
        
        textView?.attributedText = text
    }
}
