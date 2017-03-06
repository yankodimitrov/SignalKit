//
//  Scheduler.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct Scheduler {
    
    fileprivate var debounceAction: (() -> Void)? = nil
    internal let queue: DispatchQueue
    
    public init(queue: DispatchQueue) {
        
        self.queue = queue
    }
    
    public func async(_ block: @escaping ()->()) {
        
        queue.async(execute: block)
    }
    
    public func delay(_ seconds: Double, block: @escaping ()->()) {
        
        let when = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        queue.asyncAfter(deadline: when, execute: block)
    }
    
    public mutating func debounce(_ seconds: Double, block: @escaping ()->()) {
        
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
