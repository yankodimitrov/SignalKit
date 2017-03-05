//
//  MockLock.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/5/17.
//  Copyright © 2017 Yanko Dimitrov. All rights reserved.
//

import Foundation
@testable import SignalKit

final class MockLock: Lock {
    
    var lockCalled = false
    var unlockCalled = false
    
    func lock() {
        
        lockCalled = true
    }
    
    func unlock() {
        
        unlockCalled = true
    }
}
