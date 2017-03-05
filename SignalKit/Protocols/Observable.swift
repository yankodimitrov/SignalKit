//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable: class {
    associatedtype ObservationValue
    
    func addObserver(_ observer: @escaping (ObservationValue) -> Void) -> Disposable
    func sendNext(_ value: ObservationValue)
}

// MARK: - SendNext on a given queue

extension Observable {
    
    public func sendNext(_ value: ObservationValue, onQueue: SchedulerQueue) {
        
        let scheduler = Scheduler(queue: onQueue)
        
        scheduler.async { [weak self] in
            
            self?.sendNext(value)
        }
    }
}
