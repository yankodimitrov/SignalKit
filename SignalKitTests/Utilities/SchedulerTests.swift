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
        
        let expectation = self.expectation(description: "Should dispatch on main queue")
        let scheduler = Scheduler(queue: .mainQueue)
        
        scheduler.async {
            
            if Thread.isMainThread {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDispatchOnUserInteractiveQueue() {
        
        let interactiveQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        let expectation = self.expectation(description: "Should dispatch on user interactive queue")
        let scheduler = Scheduler(queue: .userInteractiveQueue)
        
        scheduler.async {
            
            if !Thread.isMainThread && interactiveQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDispatchOnUserInitiatedQueue() {
        
        let initiatedQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        let expectation = self.expectation(description: "Should dispatch on user initiated queue")
        let scheduler = Scheduler(queue: .userInitiatedQueue)
        
        scheduler.async {
            
            if !Thread.isMainThread && initiatedQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDispatchOnUtilityQueue() {
        
        let utilityQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        let expectation = self.expectation(description: "Should dispatch on utility queue")
        let scheduler = Scheduler(queue: .utilityQueue)
        
        scheduler.async {
            
            if !Thread.isMainThread && utilityQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDispatchOnBackgroundQueue() {
        
        let backgroundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        let expectation = self.expectation(description: "Should dispatch on background queue")
        let scheduler = Scheduler(queue: .backgroundQueue)
        
        scheduler.async {
            
            if !Thread.isMainThread && backgroundQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDispatchOnCustomQueue() {
        
        let customQueue = DispatchQueue(label: "signal.kit.tests.queue", attributes: DispatchQueue.Attributes.concurrent)
        let expectation = self.expectation(description: "Should dispatch on custom queue")
        let scheduler = Scheduler(queue: .customQueue(customQueue))
        
        scheduler.async {
            
            if !Thread.isMainThread && customQueue === scheduler.queue {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDelay() {
        
        let expectation = self.expectation(description: "Should dispatch an action with delay")
        let scheduler = Scheduler(queue: .mainQueue)
        
        scheduler.delay(0.1) {
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testDebounce() {
        
        let expectation = self.expectation(description: "Should debounce the execution of an action")
        var scheduler = Scheduler(queue: .mainQueue)
        var result = [Int]()
        
        scheduler.debounce(0.1) { result.append(1) }
        scheduler.debounce(0.1) { result.append(2) }
        scheduler.debounce(0.1) { result.append(3) }
        
        scheduler.delay(0.1) {
            
            if result == [3] {
                
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
