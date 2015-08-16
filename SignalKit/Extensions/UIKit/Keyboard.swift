//
//  Keyboard.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct Keyboard {
    
    public struct Event {}
    
    /**
        Returns the available Keyboard events
    
    */
    public static func observe() -> SignalEvent<Keyboard.Event> {
        
        return SignalEvent(sender: Keyboard.Event())
    }
}

// MARK: - Keyboard State

public struct KeyboardState {
    
    public var beginFrame: CGRect {
        
        guard let frame = keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return CGRectZero
        }
        
        return frame.CGRectValue()
    }
    
    public var endFrame: CGRect {
        
        guard let frame = keyboardInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return CGRectZero
        }
        
        return frame.CGRectValue()
    }
    
    public var animationCurve: UIViewAnimationCurve? {
        
        guard let curve = keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return nil
        }
        
        return UIViewAnimationCurve(rawValue: curve.integerValue)
    }
    
    public var animationDuration: Double {
        
        guard let duration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return 0
        }
        
        return duration.doubleValue
    }
    
    private let keyboardInfo: [NSObject: AnyObject]
    
    public init(notification: NSNotification) {
        
        keyboardInfo = notification.userInfo ?? [NSObject: AnyObject]()
    }
}

// MARK: - Keyboard Events

public extension SignalEventType where Sender == Keyboard.Event {
    
    private func keyboardSignalFor(notificationName: String) -> Signal<KeyboardState> {
        
        return NotificationSignal(name: notificationName).map{ KeyboardState(notification: $0) }
    }
    
    /**
        Observe for keyboard will show event
    
    */
    var willShow: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardWillShowNotification)
    }
    
    /**
        Observe for keyboard did show event
    
    */
    var didShow: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardDidShowNotification)
    }
    
    /**
        Observe for keyboard will hide event
    
    */
    var willHide: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardWillHideNotification)
    }
    
    /**
        Observe for keyboard did hide event
    
    */
    var didHide: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardDidHideNotification)
    }
    
    /**
        Observe for keyboard will change frame event
    
    */
    var willChangeFrame: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardWillChangeFrameNotification)
    }
    
    /**
        Observe for keyboard did change frame event
    
    */
    var didChangeFrame: Signal<KeyboardState> {
        
        return keyboardSignalFor(UIKeyboardDidChangeFrameNotification)
    }
}
