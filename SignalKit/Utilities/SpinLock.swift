//
//  SpinLock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

final class SpinLock: LockType {
    
    private lazy var spinlock = OS_SPINLOCK_INIT
    
    func lock() {
        
        withUnsafeMutablePointer(&spinlock, OSSpinLockLock)
    }
    
    func unlock() {
        
        withUnsafeMutablePointer(&spinlock, OSSpinLockUnlock)
    }
}
