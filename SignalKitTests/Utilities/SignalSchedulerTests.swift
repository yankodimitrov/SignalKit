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
        let scheduler = SignalScheduler.MainQueue
        
        scheduler.dispatchAsync {
            
            if NSThread.isMainThread() {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDispatchOnUserInteractiveQueue() {
        
        let interactiveQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        let expectation = expectationWithDescription("Should dispatch on user interactive queue")
        let scheduler = SignalScheduler.UserInteractiveQueue
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && interactiveQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDispatchOnUserInitiatedQueue() {
        
        let initiatedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let expectation = expectationWithDescription("Should dispatch on user initiated queue")
        let scheduler = SignalScheduler.UserInitiatedQueue
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && initiatedQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDispatchOnUtilityQueue() {
        
        let utilityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        let expectation = expectationWithDescription("Should dispatch on utility queue")
        let scheduler = SignalScheduler.UtilityQueue
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && utilityQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDispatchOnBackgroundQueue() {
        
        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        let expectation = expectationWithDescription("Should dispatch on background queue")
        let scheduler = SignalScheduler.BackgroundQueue
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && backgroundQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDispatchOnCustomQueue() {
        
        let customQueue = dispatch_queue_create("signal.kit.tests.queue", DISPATCH_QUEUE_CONCURRENT)
        let expectation = expectationWithDescription("Should dispatch on custom queue")
        let scheduler = SignalScheduler.CustomQueue(customQueue)
        
        scheduler.dispatchAsync {
            
            if !NSThread.isMainThread() && customQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDelay() {
        
        let expectation = expectationWithDescription("Should dispatch an action with delay")
        let scheduler = SignalScheduler.MainQueue
        
        scheduler.delayAfter(0.5) {
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}
