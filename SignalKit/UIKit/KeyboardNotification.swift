//
//  KeyboardNotification.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public enum KeyboardNotification {
    case WillShow
    case DidShow
    case WillHide
    case DidHide
    case WillChangeFrame
    case DidChangeFrame
    
    var name: String {
        
        switch self {
        case .WillShow: return UIKeyboardWillShowNotification
        case .DidShow: return UIKeyboardDidShowNotification
        case .WillHide: return UIKeyboardWillHideNotification
        case .DidHide: return UIKeyboardDidHideNotification
        case .WillChangeFrame: return UIKeyboardWillChangeFrameNotification
        case .DidChangeFrame: return UIKeyboardDidChangeFrameNotification
        }
    }
}

/**
    Observe for keyboard notifications

*/
public func observe(keyboard notification: KeyboardNotification) -> Signal<KeyboardState> {
    
    return observe(notification.name).map { KeyboardState(notification: $0) }
}
