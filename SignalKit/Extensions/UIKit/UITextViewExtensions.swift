//
//  UITextViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UITextView {
    
    /// Observe text changes in UITextView
    
    var text: Signal<String> {
        
        let signal = Signal<String>()
        let center = NotificationCenter.default
        let observer = NotificationObserver(center: center, name: .UITextViewTextDidChange, object: sender)
        
        observer.notificationCallback = { [weak sender, weak signal] _ in
        
            signal?.send(sender?.text ?? "")
        }
        
        signal.disposableSource = observer
        
        return signal
    }
}
