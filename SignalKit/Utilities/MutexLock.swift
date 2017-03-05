//
//  MutexLock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/17.
//  Copyright © 2017 Yanko Dimitrov. All rights reserved.
//

import Foundation

public final class MutexLock: Lock {
    
    fileprivate var mutex = pthread_mutex_t()
    
    public init() {}
}

// MARK: - Lock

extension MutexLock {
    
    public func lock() {
        
        pthread_mutex_lock(&mutex)
    }
    
    public func unlock() {
        
        pthread_mutex_unlock(&mutex)
    }
}
