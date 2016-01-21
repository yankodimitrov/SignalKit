//
//  Observable.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public protocol Observable: class {
    typealias ObservationType
    
    var dispatcher: Dispatcher<ObservationType> {get}
    
    func addObserver(observer: ObservationType -> Void) -> Disposable
    func dispatch(item: ObservationType)
    func removeObservers()
}

public extension Observable {
    
    public func addObserver(observer: ObservationType -> Void) -> Disposable {
        
        return dispatcher.addObserver(observer)
    }
    
    public func dispatch(item: ObservationType) {
        
        dispatcher.dispatch(item)
    }
    
    public func removeObservers() {
        
        dispatcher.removeObservers()
    }
}

public extension Observable {
    
    public func dispatch(item: ObservationType, onQueue: SignalScheduler.Queue) {
        
        let scheduler = SignalScheduler(queue: onQueue)
        
        scheduler.dispatchAsync({ [weak self] in
            
            self?.dispatcher.dispatch(item)
        })
    }
}
