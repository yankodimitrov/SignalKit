//
//  KeyboardState.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

public struct KeyboardState {
    
    public var beginFrame: CGRect {
        
        let beginFrameKey = UIKeyboardFrameBeginUserInfoKey
        
        if let value = keyboardInfo[beginFrameKey] as? NSValue {
            
            return value.CGRectValue()
        }
        
        return CGRectZero
    }
    
    public var endFrame: CGRect {
        
        let endFrameKey = UIKeyboardFrameEndUserInfoKey
        
        if let value = keyboardInfo[endFrameKey] as? NSValue {
            
            return value.CGRectValue()
        }
        
        return CGRectZero
    }
    
    public var animationCurve: UIViewAnimationCurve {
        
        let animationCurveKey = UIKeyboardAnimationCurveUserInfoKey
        
        if let number = keyboardInfo[animationCurveKey] as? NSNumber,
            let animationCurve = UIViewAnimationCurve(rawValue: number.integerValue) {
                
                return animationCurve
        }
        
        return .EaseInOut
    }
    
    public var animationDuration: Double {
        
        let animationDurationKey = UIKeyboardAnimationDurationUserInfoKey
        
        if let number = keyboardInfo[animationDurationKey] as? NSNumber {
            
            return number.doubleValue
        }
        
        return 0
    }
    
    private let keyboardInfo: [NSObject: AnyObject]
    
    init(notification: NSNotification) {
        
        keyboardInfo = notification.userInfo ?? [NSObject: AnyObject]()
    }
}
