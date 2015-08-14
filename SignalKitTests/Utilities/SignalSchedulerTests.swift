//
//  SignalSchedulerTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/13/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class SignalSchedulerTests: XCTestCase {
    
    func testDispatchOnMainQueue() {
    
        let expectation = expectationWithDescription("Should dispatch on main queue")
        let scheduler = SignalScheduler(queue: .MainQueue)
        
        scheduler.dispatchAsync {
            
            if NSThread.isMainThread() {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnUserInteractiveQueue() {
        
        let interactiveQueue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        let expectation = expectationWithDescription("Should dispatch on user interactive queue")
        let scheduler = SignalScheduler(queue: .UserInteractiveQueue)
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && interactiveQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnUserInitiatedQueue() {
        
        let initiatedQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        let expectation = expectationWithDescription("Should dispatch on user initiated queue")
        let scheduler = SignalScheduler(queue: .UserInitiatedQueue)
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && initiatedQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnUtilityQueue() {
        
        let utilityQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        let expectation = expectationWithDescription("Should dispatch on utility queue")
        let scheduler = SignalScheduler(queue: .UtilityQueue)
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && utilityQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnBackgroundQueue() {
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        let expectation = expectationWithDescription("Should dispatch on background queue")
        let scheduler = SignalScheduler(queue: .BackgroundQueue)
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && backgroundQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnCustomQueue() {
        
        let customQueue = dispatch_queue_create("signal.kit.tests.queue", DISPATCH_QUEUE_CONCURRENT)
        let expectation = expectationWithDescription("Should dispatch on custom queue")
        let scheduler = SignalScheduler(queue: .CustomQueue(customQueue))
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && customQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDelay() {
        
        let expectation = expectationWithDescription("Should dispatch an action with delay")
        let scheduler = SignalScheduler(queue: .MainQueue)
        
        scheduler.delay(0.1) {
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDebounce() {
        
        let expectation = expectationWithDescription("Should debounce the execution of an action")
        var scheduler = SignalScheduler(queue: .MainQueue)
        var result = 0
        
        scheduler.debounce(0.1) { result = 1 }
        scheduler.debounce(0.1) { result = 2 }
        scheduler.debounce(0.1) { result = 3 }
        
        scheduler.delay(0.1) {
            
            if result == 3 {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
