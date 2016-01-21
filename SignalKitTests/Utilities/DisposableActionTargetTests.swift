//
//  DisposableActionTargetTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class DisposableActionTargetTests: XCTestCase {
    
    func testInitWithActionCallback() {
        
        var isActionCalled = false
        
        let actionTarget = DisposableActionTarget { _ in
            
            isActionCalled = true
        }
        
        actionTarget.handleAction(sender: NSObject())
        
        XCTAssertEqual(isActionCalled, true, "Should call the action callback")
    }
    
    func testDispose() {
        
        var isActionCalled = false
        
        let actionTarget = DisposableActionTarget { _ in
            
            isActionCalled = true
        }
        
        actionTarget.dispose()
        actionTarget.handleAction(sender: NSObject())

        XCTAssertEqual(isActionCalled, false, "Should dispose the callback")
    }
    
    func testActionSelector() {
        
        let expectedSelector = Selector("handleAction:")
        
        let actionTarget = DisposableActionTarget(actionCallback: { _ in })
        
        XCTAssertEqual(actionTarget.actionSelector, expectedSelector, "Should return the expected selector signature")
    }
}
