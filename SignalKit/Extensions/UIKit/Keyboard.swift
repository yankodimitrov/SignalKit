//
//  Keyboard.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public struct Keyboard {
    
    public struct EventSender {}
    
    /// Returns the available Keyboard events
    
    public static func observe() -> SignalEvent<Keyboard.EventSender> {
        
        return SignalEvent(sender: Keyboard.EventSender())
    }
}

// MARK: - Keyboard State

public struct KeyboardState {
    
    public var beginFrame: CGRect {
        
        guard let frame = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return CGRect.zero
        }
        
        return frame.cgRectValue
    }
    
    public var endFrame: CGRect {
        
        guard let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return CGRect.zero
        }
        
        return frame.cgRectValue
    }
    
    public var animationCurve: UIViewAnimationCurve? {
        
        guard let curve = info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return nil
        }
        
        return UIViewAnimationCurve(rawValue: curve.intValue)
    }
    
    public var animationDuration: Double {
        
        guard let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return 0
        }
        
        return duration.doubleValue
    }
    
    fileprivate let info: [AnyHashable: Any]
    
    public init(notification: Notification) {
        
        info = notification.userInfo ?? [AnyHashable: Any]()
    }
}

// MARK: - Keyboard Events

public extension Event where Sender == Keyboard.EventSender {
    
    fileprivate func keyboardSignalFor(_ name: Notification.Name) -> Signal<KeyboardState> {
        
        let signal = Signal<KeyboardState>()
        let observer = NotificationObserver(center: NotificationCenter.default, name: name)
        
        observer.notificationCallback = { [weak signal] in
            
            signal?.send(KeyboardState(notification: $0))
        }
        
        signal.disposableSource = observer
        
        return signal
    }
    
    /// Observe for keyboard will show event
    
    var willShow: Signal<KeyboardState> {
        
        return keyboardSignalFor(.UIKeyboardWillShow)
    }
    
    /// Observe for keyboard did show event
    
    var didShow: Signal<KeyboardState> {
        
        return keyboardSignalFor(.UIKeyboardDidShow)
    }
    
    /// Observe for keyboard will hide event
    
    var willHide: Signal<KeyboardState> {
        
        return keyboardSignalFor(.UIKeyboardWillHide)
    }
    
    /// Observe for keyboard did hide event
    
    var didHide: Signal<KeyboardState> {
        
        return keyboardSignalFor(.UIKeyboardDidHide)
    }
    
    /// Observe for keyboard will change frame event
    
    var willChangeFrame: Signal<KeyboardState> {
        
        return keyboardSignalFor(.UIKeyboardWillChangeFrame)
    }
    
    /// Observe for keyboard did change frame event
    
    var didChangeFrame: Signal<KeyboardState> {
        
        return keyboardSignalFor(.UIKeyboardDidChangeFrame)
    }
}
