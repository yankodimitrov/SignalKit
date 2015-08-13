//
//  SignalScheduler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/13/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

private struct SignalQueue {
    
    static let mainQueue = dispatch_get_main_queue()
    static let highQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    static let defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    static let utilityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    static let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
}

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
            queue = SignalQueue.mainQueue
        
        case .UserInteractiveQueue:
            queue = SignalQueue.highQueue
        
        case .UserInitiatedQueue:
            queue = SignalQueue.defaultQueue
        
        case .UtilityQueue:
            queue = SignalQueue.utilityQueue
        
        case .BackgroundQueue:
            queue = SignalQueue.backgroundQueue
        
        case .CustomQueue(let customQueue):
            queue = customQueue
        }
        
        return queue
    }
    
    func dispatchAsync(block: dispatch_block_t) {
        
        dispatch_async(queue, block)
    }
    
    func delayAfter(seconds: Double, block: dispatch_block_t) {
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(when, queue, block)
    }
}
