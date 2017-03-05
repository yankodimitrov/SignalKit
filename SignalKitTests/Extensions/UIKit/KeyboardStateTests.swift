//
//  KeyboardStateTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class KeyboardStateTests: XCTestCase {

    let beginFrame = CGRect(x: 0, y: 0, width: 100, height: 200)
    let endFrame = CGRect(x: 0, y: 200, width: 100, height: 200)
    let animationCurve = UIViewAnimationCurve.easeInOut
    let animationDuration: Double = 0.5
    
    var keyboardInfo: [AnyHashable: Any]!
    var notification: Notification!
    
    override func setUp() {
        super.setUp()
        
        keyboardInfo = [AnyHashable: Any]()
        
        keyboardInfo[UIKeyboardFrameBeginUserInfoKey] = NSValue(cgRect: beginFrame)
        keyboardInfo[UIKeyboardFrameEndUserInfoKey] =  NSValue(cgRect: endFrame)
        keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] = NSNumber(value: animationCurve.rawValue as Int)
        keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] = NSNumber(value: animationDuration as Double)
        
        notification = Notification(name: Notification.Name(rawValue: "test"), object: nil, userInfo: keyboardInfo)
    }
    
    func testBeginFrame() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.beginFrame, beginFrame, "Should return the begin frame")
    }
    
    func testBeginFrameKeyMissing() {
        
        keyboardInfo[UIKeyboardFrameBeginUserInfoKey] = nil
        
        let notification = Notification(name: Notification.Name(rawValue: "test"), object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.beginFrame, CGRect.zero, "When begin frame key is missing should return CGRectZero")
    }
    
    func testEndFrame() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.endFrame, endFrame, "Should return the end frame")
    }
    
    func testEndFrameKeyMissing() {
        
        keyboardInfo[UIKeyboardFrameEndUserInfoKey] = nil
        
        let notification = Notification(name: Notification.Name(rawValue: "test"), object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.endFrame, CGRect.zero, "When end frame key is missing should return CGRectZero")
    }
    
    func testAnimationCurve() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationCurve, animationCurve, "Should return the animation curve")
    }
    
    func testAnimationCurveKeyMissing() {
        
        keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] = nil
        
        let notification = Notification(name: Notification.Name(rawValue: "test"), object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationCurve, nil, "When animation curve key is missing should return nil")
    }
    
    func testAnimationDuration() {
        
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationDuration, animationDuration, "Should return the animation duration")
    }
    
    func testAnimationDurationKeyMissing() {
        
        keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] = nil
        
        let notification = Notification(name: Notification.Name(rawValue: "test"), object: nil, userInfo: keyboardInfo)
        let keyboardState = KeyboardState(notification: notification)
        
        XCTAssertEqual(keyboardState.animationDuration, 0, "When animation duration key is missing should return 0")
    }
}
