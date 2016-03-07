//
//  Scheduler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public enum SchedulerQueue {
    
    case MainQueue
    case UserInteractiveQueue
    case UserInitiatedQueue
    case UtilityQueue
    case BackgroundQueue
    case CustomQueue(dispatch_queue_t)
    
    var dispatchQueue: dispatch_queue_t {
        
        switch self {
            
        case .MainQueue:
            return dispatch_get_main_queue()
            
        case .UserInteractiveQueue:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
            
        case .UserInitiatedQueue:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            
        case .UtilityQueue:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
            
        case .BackgroundQueue:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
            
        case .CustomQueue(let customQueue):
            return customQueue
        }
    }
}

public struct Scheduler {
    
    private var debounceAction: (() -> Void)? = nil
    internal let queue: dispatch_queue_t
    
    public init(queue: SchedulerQueue) {
        
        self.queue = queue.dispatchQueue
    }
    
    public func async(block: dispatch_block_t) {
        
        dispatch_async(queue, block)
    }
    
    public func delay(seconds: Double, block: dispatch_block_t) {
        
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(when, queue, block)
    }
    
    public mutating func debounce(seconds: Double, block: dispatch_block_t) {
        
        debounceAction?()
        
        var isCancelled = false
        
        delay(seconds) {
            
            if !isCancelled {
                
                block()
            }
        }
        
        debounceAction = { isCancelled = true }
    }
}
