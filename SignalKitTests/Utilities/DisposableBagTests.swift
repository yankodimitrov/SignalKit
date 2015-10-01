//
//  DisposableBagTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class DisposableBagTests: XCTestCase {
    
    var bag: DisposableBag!
    var signal: MockSignal<Int>!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
        signal = MockSignal<Int>()
    }
    
    func testAddDisposable() {
        
        bag.addDisposable(signal)
        
        XCTAssertEqual(bag.count, 1, "Should add the signal to the bag")
    }
    
    func testDisposeItem() {
        
        let disposable = bag.addDisposable(signal)
        
        disposable.dispose()
        
        XCTAssertEqual(bag.count, 0, "Should remove the signal from the bag upon disposal")
    }
    
    func testRemoveAll() {
        
        let signalTwo = MockSignal<String>()
        
        bag.addDisposable(signal)
        bag.addDisposable(signalTwo)
        
        bag.removeAll()
        
        XCTAssertEqual(bag.count, 0, "Should remove all signals from the bag")
    }
}
