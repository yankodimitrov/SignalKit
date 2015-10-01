//
//  UISwitch+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UISwitch_SignalTests: XCTestCase {
    
    var switchControl: MockSwitch!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        switchControl = MockSwitch()
        signalsBag = DisposableBag()
    }
    
    func testObserveOnState() {
        
        var result = false
        
        switchControl.on = false
        
        switchControl.observe().onState
            .next { result = $0 }
            .addTo(signalsBag)
        
        switchControl.on = true
        switchControl.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, true, "Should observe the on/off state changes in UISwitch")
    }
    
    func testObserveCurrentOnState() {
        
        var result = false
        
        switchControl.on = true
        
        switchControl.observe().onState
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, true, "Should dispatch the current on/off state in UISwitch")
    }
    
    func testBindToOnState() {
        
        let signal = MockSignal<Bool>()
        
        signal.dispatch(true)
        
        signal.bindTo(onStateIn: switchControl).addTo(signalsBag)
        
        XCTAssertEqual(switchControl.on, true, "Should bind a boolean value to the on/off state in UISwitch")
    }
}
