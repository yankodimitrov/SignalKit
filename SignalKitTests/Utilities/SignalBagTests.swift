//
//  SignalBagTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class SignalBagTests: XCTestCase {
    
    var bag: SignalBag!
    var signal: MockSignal<Int>!
    
    override func setUp() {
        super.setUp()
        
        bag = SignalBag()
        signal = MockSignal<Int>()
    }
    
    func testAddSignal() {
        
        bag.addSignal(signal)
        
        XCTAssertEqual(bag.signalsCount, 1, "Should add the signal to the bag")
    }
    
    func testDisposeSignal() {
        
        let disposable = bag.addSignal(signal)
        
        disposable.dispose()
        
        XCTAssertEqual(bag.signalsCount, 0, "Should remove the signal from the bag upon disposal")
    }
    
    func testRemoveSignals() {
        
        let signalTwo = MockSignal<String>()
        
        bag.addSignal(signal)
        bag.addSignal(signalTwo)
        
        bag.removeSignals()
        
        XCTAssertEqual(bag.signalsCount, 0, "Should remove all signals from the bag")
    }
}
