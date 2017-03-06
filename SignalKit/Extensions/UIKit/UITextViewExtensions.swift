//
//  UITextViewExtensions.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public extension Event where Sender: UITextView {
    
    /// Observe for text changes in UITextView.
    var text: Signal<String> {
        
        let signal = Signal<String>()
        let observer = NotificationObserver(center: .default, name: .UITextViewTextDidChange, object: sender)
        
        observer.notificationCallback = { [weak sender, weak signal] _ in
        
            signal?.send(sender?.text ?? "")
        }
        
        signal.disposableSource = observer
        
        return signal
    }
}
