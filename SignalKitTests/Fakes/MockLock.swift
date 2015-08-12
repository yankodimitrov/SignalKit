//
//  MockLock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class MockLock: LockType {
    
    var synchronizationCounter = 0
    var isLockCalled = false
    var isUnlockCalled = false
    
    func lock() {
        
        synchronizationCounter += 1
        isLockCalled = true
    }
    
    func unlock() {
        
        synchronizationCounter -= 1
        isUnlockCalled = true
    }
}
