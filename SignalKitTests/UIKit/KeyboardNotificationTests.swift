//
//  KeyboardNotificationTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class KeyboardNotificationTests: XCTestCase {

    let center = NSNotificationCenter.defaultCenter()
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        signalsBag = SignalBag()
    }
    
    func testObserveKeyboardWillShow() {
        
        var called = false
        
        observe(keyboard: .WillShow)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardWillShowNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard will show notifications")
    }
    
    func testObserveKeyboardDidShow() {
        
        var called = false
        
        observe(keyboard: .DidShow)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardDidShowNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard did show notifications")
    }
    
    func testObserveKeyboardWillHide() {
        
        var called = false
        
        observe(keyboard: .WillHide)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard will hide notifications")
    }
    
    func testObserveKeyboardDidHide() {
        
        var called = false
        
        observe(keyboard: .DidHide)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardDidHideNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard did hide notifications")
    }
    
    func testObserveKeyboardWillChangeFrame() {
        
        var called = false
        
        observe(keyboard: .WillChangeFrame)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardWillChangeFrameNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard will change frame notifications")
    }
    
    func testObserveKeyboardDidChangeFrame() {
        
        var called = false
        
        observe(keyboard: .DidChangeFrame)
            .next { _ in called = true }
            .addTo(signalsBag)
        
        center.postNotificationName(UIKeyboardDidChangeFrameNotification, object: nil)
        
        XCTAssertEqual(called, true, "Should observe for keyboard did change frame notifications")
    }
}
