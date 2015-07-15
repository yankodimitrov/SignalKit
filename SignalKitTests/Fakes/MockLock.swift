//
//  MockLock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class MockLock: LockType {
    
    var syncCounter = 0
    var lockCalled = false
    var unlockCalled = false
    
    func lock() {
        
        syncCounter += 1
        lockCalled = true
    }
    
    func unlock() {
        
        syncCounter -= 1
        unlockCalled = true
    }
}
