//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/4/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable: class {
    typealias ObservationValue
    
    func addObserver(observer: ObservationValue -> Void) -> Disposable
    func sendNext(value: ObservationValue)
}

// MARK: - SendNext on a given queue

extension Observable {
    
    public func sendNext(value: ObservationValue, onQueue: SchedulerQueue) {
        
        let scheduler = Scheduler(queue: onQueue)
        
        scheduler.async { [weak self] in
            
            self?.sendNext(value)
        }
    }
}
