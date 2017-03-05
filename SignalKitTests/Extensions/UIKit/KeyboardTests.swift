//
//  KeyboardTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class KeyboardTests: XCTestCase {
    
    let center = NotificationCenter.default
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveWillShow() {
        
        var called = false
        
        Keyboard.observe().willShow
            .next{ _ in called = true }
            .disposeWith(bag)
        
        center.post(name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        XCTAssertTrue(called, "Should observe for keyboard will show notification")
    }
    
    func testObserveDidShow() {
        
        var called = false
        
        Keyboard.observe().didShow
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        XCTAssertTrue(called, "Should observe for keyboard did show notification")
    }
    
    func testObserveWillHide() {
        
        var called = false
        
        Keyboard.observe().willHide
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        XCTAssertTrue(called, "Should observe for keyboard will hide notification")
    }
    
    func testObserveDidHide() {
        
        var called = false
        
        Keyboard.observe().didHide
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        XCTAssertTrue(called, "Should observe for keyboard did hide notification")
    }
    
    func testObserveWillChangeFrame() {
        
        var called = false
        
        Keyboard.observe().willChangeFrame
            .next { _ in called = true }
            .disposeWith(bag)
        
        center.post(name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        XCTAssertTrue(called, "Should observe fok keyboard will change frame notificaiton")
    }
    
    func testObserveDidChangeFrame() {
        
        var called = false
        
        Keyboard.observe().didChangeFrame
            .next { _ in called = true}
            .disposeWith(bag)
        
        center.post(name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        XCTAssertTrue(called, "Should observe for keyboard did change frame notification")
    }
}
