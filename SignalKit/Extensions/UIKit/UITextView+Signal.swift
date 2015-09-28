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
        
        let signal = Signal<String>()
        let notificationSignal = NotificationSignal(name: UITextViewTextDidChangeNotification, fromObject: sender)
        
        notificationSignal.addObserver { [weak sender, weak signal] _ in
            
            if let text = sender?.text {
                signal?.dispatch(text)
            }
        }
        
        signal.disposableSource = notificationSignal
        
        if let text = sender.text {
            signal.dispatch(text)
        }
        
        return signal
    }
    
    /**
        Observe the attributed text changes in UITextView
    
    */
    public var attributedText: Signal<NSAttributedString> {
        
        let signal = Signal<NSAttributedString>()
        let notificationSignal = NotificationSignal(name: UITextViewTextDidChangeNotification, fromObject: sender)
        
        notificationSignal.addObserver { [weak sender, weak signal] _ in
            
            if let text = sender?.attributedText {
                signal?.dispatch(text)
            }
        }
        
        signal.disposableSource = notificationSignal
        
        if let text = sender.attributedText {
            signal.dispatch(text)
        }
        
        return signal
    }
}

public extension SignalType where ObservationType == String {
    
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

public extension SignalType where ObservationType == NSAttributedString {
    
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
