//
//  Keyboard.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import UIKit

public struct Keyboard {
    
    public struct Event {}
    
    /// Returns the available Keyboard events
    
    public static func observe() -> SignalEvent<Keyboard.Event> {
        
        return SignalEvent(sender: Keyboard.Event())
    }
}

// MARK: - Keyboard State

public struct KeyboardState {
    
    public var beginFrame: CGRect {
        
        guard let frame = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return CGRectZero
        }
        
        return frame.CGRectValue()
    }
    
    public var endFrame: CGRect {
        
        guard let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return CGRectZero
        }
        
        return frame.CGRectValue()
    }
    
    public var animationCurve: UIViewAnimationCurve? {
        
        guard let curve = info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return nil
        }
        
        return UIViewAnimationCurve(rawValue: curve.integerValue)
    }
    
    public var animationDuration: Double {
        
        guard let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return 0
        }
        
        return duration.doubleValue
    }
    
    private let info: [NSObject: AnyObject]
    
    public init(notification: NSNotification) {
        
        info = notification.userInfo ?? [NSObject: AnyObject]()
    }
}

// MARK: - Keyboard Events

public extension SignalEventType where Sender == Keyboard.Event {
    
    private func keyboardSignalFor(notificationName: String) -> Signal<KeyboardState> {
        
        let signal = Signal<KeyboardState>()
        let center = NSNotificationCenter.defaultCenter()
        let observer = NotificationObserver(center: center, name: notificationName)
        
        observer.notificationCallback = { [weak signal] in
            
            signal?.sendNext(KeyboardState(notification: $0))
        }
        
        signal.disposableSource = observer
        
        return signal
    }
    
    /// Observe for keyboard will show event
    
    var willShow: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardWillShowNotification)
    }
    
    /// Observe for keyboard did show event
    
    var didShow: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardDidShowNotification)
    }
    
    /// Observe for keyboard will hide event
    
    var willHide: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardWillHideNotification)
    }
    
    /// Observe for keyboard did hide event
    
    var didHide: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardDidHideNotification)
    }
    
    /// Observe for keyboard will change frame event
    
    var willChangeFrame: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardWillChangeFrameNotification)
    }
    
    /// Observe for keyboard did change frame event
    
    var didChangeFrame: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardDidChangeFrameNotification)
    }
}
