//
//  SpinLock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
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
