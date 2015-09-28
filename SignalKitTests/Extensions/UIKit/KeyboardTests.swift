//
//  KeyboardTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class KeyboardTests: XCTestCase {

    let center = NSNotificationCenter.defaultCenter()
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        signalsBag = SignalBag()
    }
    
    func testObserveWillShow() {
        
        var called = false
        
        Keyboard.observe().willShow
            .next{ _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardWillShowNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard will show notification")
    }
    
    func testObserveDidShow() {
        
        var called = false
        
        Keyboard.observe().didShow
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardDidShowNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard did show notification")
    }
    
    func testObserveWillHide() {
        
        var called = false
        
        Keyboard.observe().willHide
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard will hide notification")
    }
    
    func testObserveDidHide() {
        
        var called = false
        
        Keyboard.observe().didHide
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardDidHideNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard did hide notification")
    }
    
    func testObserveWillChangeFrame() {
        
        var called = false
        
        Keyboard.observe().willChangeFrame
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardWillChangeFrameNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe fok keyboard will change frame notificaiton")
    }
    
    func testObserveDidChangeFrame() {
        
        var called = false
        
        Keyboard.observe().didChangeFrame
            .next { _ in called = true}
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardDidChangeFrameNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard did change frame notification")
    }
}
