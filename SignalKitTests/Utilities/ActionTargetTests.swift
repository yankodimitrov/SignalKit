//
//  ActionTargetTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class ActionTargetTests: XCTestCase {
    
    func testHandleAction() {
        
        let actionTarget = ActionTarget()
        var called = false
        
        actionTarget.actionCallback = { _ in
            
            called = true
        }
        
        actionTarget.handleAction(NSObject())
        
        XCTAssertTrue(called, "Should call the action callback")
    }
    
    func testDispose() {
        
        let actionTarget = ActionTarget()
        var called = false
        
        actionTarget.disposeAction = DisposableAction {
            called = true
        }
        
        actionTarget.dispose()
        
        XCTAssertTrue(called, "Should call the dispose action")
    }
    
    func testDisposeOnDeinit() {
        
        var actionTarget: ActionTarget? = ActionTarget()
        var called = false
        
        actionTarget?.disposeAction = DisposableAction {
            called = true
        }
        
        actionTarget = nil
        
        XCTAssertTrue(called, "Should dispose on deinit")
    }
}
