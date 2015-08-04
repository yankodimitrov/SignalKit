//
//  SignalBagTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class SignalBagTests: XCTestCase {

    var lock: MockLock!
    var signal: MockSignal!
    var container: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        lock = MockLock()
        signal = MockSignal()
        container = SignalBag(lock: lock)
    }
    
    func testAddSignal() {
        
        container.addSignal(signal)
        
        XCTAssertEqual(container.signalsCount, 1, "Should add a signal to container")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testRemoveSignal() {
        
        let item = container.addSignal(signal)
        
        lock.lockCalled = false
        lock.unlockCalled = false
        
        item.dispose()
        
        XCTAssertEqual(container.signalsCount, 0, "Should remove a signal from the container")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
    
    func testRemoveSignals() {
        
        let signalTwo = MockSignal()
        let signalThree = MockSignal()
        
        container.addSignal(signal)
        container.addSignal(signalTwo)
        container.addSignal(signalThree)
        
        container.removeSignals()
        
        XCTAssertEqual(container.signalsCount, 0, "Should remove all signals from the container")
        XCTAssertEqual(lock.lockCalled, true, "Should perform lock")
        XCTAssertEqual(lock.unlockCalled, true, "Should perform unlock")
        XCTAssertEqual(lock.syncCounter, 0, "Should perform balanced calls to lock() / unlock()")
    }
}
