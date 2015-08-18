//
//  UITextView+Signal.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension SignalEventType where Sender: UITextView {
    
    /**
        Observe the text changes in UITextView
    
    */
    public var text: Signal<String> {
        
        let notification = NotificationSignal(name: UITextViewTextDidChangeNotification, fromObject: sender)
        
        let signal = notification.map { [weak sender] _ in
            
            return sender?.text ?? ""
        }
        
        signal.dispatch(sender.text ?? "")
        
        return signal
    }
    
    /**
        Observe the attributed text changes in UITextView
    
    */
    public var attributedText: Signal<NSAttributedString> {
        
        let notification = NotificationSignal(name: UITextViewTextDidChangeNotification, fromObject: sender)
        
        let signal = notification.map { [weak sender] _ in
            
            return sender?.attributedText ?? NSAttributedString(string: "")
        }
        
        signal.dispatch(sender.attributedText ?? NSAttributedString(string: ""))
        
        return signal
    }
}

public extension SignalType where Item == String {
    
    /**
        Bind a String value to the text property of UITextView
    
    */
    public func bindTo(textIn textView: UITextView) -> Self {
        
        addObserver { [weak textView] in
            
            textView?.text = $0
        }
        
        return self
    }
}

public extension SignalType where Item == NSAttributedString {
    
    /**
        Bind a NSAttributedString to the attributed text property of UITextView
    
    */
    public func bindTo(attributedTextIn textView: UITextView) -> Self {
        
        addObserver { [weak textView] in
            
            textView?.attributedText = $0
        }
        
        return self
    }
}
