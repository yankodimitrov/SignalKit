//
//  KeyboardStateTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class KeyboardStateTests: XCTestCase {

    let beginFrame = CGRectMake(0, 0, 100, 200)
    let endFrame = CGRectMake(0, 200, 100, 200)
    let animationCurve = UIViewAnimationCurve.EaseInOut
    let animationDuration: Double = 0.5
    
    var keyboardInfo: [NSObject: AnyObject]!
    var notification: NSNotification!
    
    override func setUp() {
        super.setUp()
        
        keyboardInfo = [NSObject: AnyObject]()
        
        keyboardInfo[UIKeyboardFrameBeginUserInfoKey] = NSValue(CGRect: beginFrame)
        keyboardInfo[UIKeyboardFrameEndUserInfoKey] =  NSValue(CGRect: endFrame)
        keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] = NSNumber(integer: animationCurve.rawValue)
        keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] = NSNumber(double: animationDuration)
        
        notification = NSNotification(name: "test", object: nil, userInfo: keyboardInfo)
    }
    
    func testBeginFrame() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.beginFrame, beginFrame, "Should return the begin frame")
    }
    
    func testBeginFrameKeyMissing() {
        
        keyboardInfo[UIKeyboardFrameBeginUserInfoKey] = nil
        
        let notification = NSNotification(name: "test", object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.beginFrame, CGRectZero, "When begin frame key is missing should return CGRectZero")
    }
    
    func testEndFrame() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.endFrame, endFrame, "Should return the end frame")
    }
    
    func testEndFrameKeyMissing() {
        
        keyboardInfo[UIKeyboardFrameEndUserInfoKey] = nil
        
        let notification = NSNotification(name: "test", object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.endFrame, CGRectZero, "When end frame key is missing should return CGRectZero")
    }
    
    func testAnimationCurve() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationCurve, animationCurve, "Should return the animation curve")
    }
    
    func testAnimationCurveKeyMissing() {
        
        keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] = nil
        
        let notification = NSNotification(name: "test", object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationCurve, .EaseInOut, "When animation curve key is missing should return .EaseInOut")
    }
    
    func testAnimationDuration() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationDuration, animationDuration, "Should return the animation duration")
    }
    
    func testAnimationDurationKeyMissing() {
        
        keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] = nil
        
        let notification = NSNotification(name: "test", object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationDuration, 0, "When animation duration key is missing should return 0")
    }
}
