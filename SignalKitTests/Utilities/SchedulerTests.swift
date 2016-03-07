//
//  SchedulerTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class SchedulerTests: XCTestCase {
    
    func testDispatchOnMainQueue() {
        
        let expectation = expectationWithDescription("Should dispatch on main queue")
        let scheduler = Scheduler(queue: .MainQueue)
        
        scheduler.async {
            
            if NSThread.isMainThread() {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnUserInteractiveQueue() {
        
        let interactiveQueue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        let expectation = expectationWithDescription("Should dispatch on user interactive queue")
        let scheduler = Scheduler(queue: .UserInteractiveQueue)
        
        scheduler.async {
            
            if !NSThread.isMainThread() && interactiveQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnUserInitiatedQueue() {
        
        let initiatedQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        let expectation = expectationWithDescription("Should dispatch on user initiated queue")
        let scheduler = Scheduler(queue: .UserInitiatedQueue)
        
        scheduler.async {
            
            if !NSThread.isMainThread() && initiatedQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnUtilityQueue() {
        
        let utilityQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        let expectation = expectationWithDescription("Should dispatch on utility queue")
        let scheduler = Scheduler(queue: .UtilityQueue)
        
        scheduler.async {
            
            if !NSThread.isMainThread() && utilityQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnBackgroundQueue() {
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        let expectation = expectationWithDescription("Should dispatch on background queue")
        let scheduler = Scheduler(queue: .BackgroundQueue)
        
        scheduler.async {
            
            if !NSThread.isMainThread() && backgroundQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDispatchOnCustomQueue() {
        
        let customQueue = dispatch_queue_create("signal.kit.tests.queue", DISPATCH_QUEUE_CONCURRENT)
        let expectation = expectationWithDescription("Should dispatch on custom queue")
        let scheduler = Scheduler(queue: .CustomQueue(customQueue))
        
        scheduler.async {
            
            if !NSThread.isMainThread() && customQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDelay() {
        
        let expectation = expectationWithDescription("Should dispatch an action with delay")
        let scheduler = Scheduler(queue: .MainQueue)
        
        scheduler.delay(0.1) {
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testDebounce() {
        
        let expectation = expectationWithDescription("Should debounce the execution of an action")
        var scheduler = Scheduler(queue: .MainQueue)
        var result = [Int]()
        
        scheduler.debounce(0.1) { result.append(1) }
        scheduler.debounce(0.1) { result.append(2) }
        scheduler.debounce(0.1) { result.append(3) }
        
        scheduler.delay(0.1) {
            
            if result == [3] {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
