//
//  SignalScheduler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/13/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public enum SignalScheduler {
    
    case MainQueue
    case UserInteractiveQueue
    case UserInitiatedQueue
    case UtilityQueue
    case BackgroundQueue
    case CustomQueue(dispatch_queue_t)
    
    var queue: dispatch_queue_t {
        
        let queue: dispatch_queue_t
        
        switch self {
        
        case .MainQueue:
            queue = dispatch_get_main_queue()
        
        case .UserInteractiveQueue:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        
        case .UserInitiatedQueue:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        case .UtilityQueue:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        case .BackgroundQueue:
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        
        case .CustomQueue(let customQueue):
            queue = customQueue
        }
        
        return queue
    }
    
    func dispatchAsync(block: () -> Void) {
        
        dispatch_async(queue, block)
    }
    
    func delayAfter(seconds: Double, block: () -> Void) {
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(when, queue, block)
    }
}
