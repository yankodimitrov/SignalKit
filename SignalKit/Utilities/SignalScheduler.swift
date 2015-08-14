//
//  SignalScheduler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/13/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct SignalScheduler {
    
    public enum Queue {
        case MainQueue
        case UserInteractiveQueue
        case UserInitiatedQueue
        case UtilityQueue
        case BackgroundQueue
        case CustomQueue(dispatch_queue_t)
        
        var dispatchQueue: dispatch_queue_t {
            
            let queue: dispatch_queue_t
            
            switch self {
                
            case .MainQueue:
                queue = dispatch_get_main_queue()
                
            case .UserInteractiveQueue:
                queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
                
            case .UserInitiatedQueue:
                queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
                
            case .UtilityQueue:
                queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
                
            case .BackgroundQueue:
                queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
                
            case .CustomQueue(let customQueue):
                queue = customQueue
            }
            
            return queue
        }
    }
    
    let queue: dispatch_queue_t
    
    public init(queue: Queue) {
        
        self.queue = queue.dispatchQueue
    }
    
    func dispatchAsync(block: dispatch_block_t) {
        
        dispatch_async(queue, block)
    }
    
    func delayAfter(seconds: Double, block: dispatch_block_t) {
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(when, queue, block)
    }
    
    var debounceAction: (() -> Void)? = nil
    
    mutating func debounce(seconds: Double, block: dispatch_block_t) {
        
        debounceAction?()
        
        var cancelled = false
        
        delayAfter(seconds) {
            
            if !cancelled {
                
                block()
            }
        }
        
        debounceAction = { cancelled = true }
    }
}
