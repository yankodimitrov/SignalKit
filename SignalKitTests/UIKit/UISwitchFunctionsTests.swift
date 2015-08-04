//
//  UISwitchFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UISwitchFunctionsTests: XCTestCase {

    var switchControl: MockSwitch!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        switchControl = MockSwitch()
        signalsBag = SignalBag()
    }
    
    func testObserveOnStateInSwitch() {
        
        var result = false
        
        observe(switchIsOn: switchControl)
            .next { result = $0 }
            .addTo(signalsBag)
        
        switchControl.on = true
        switchControl.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, true, "Should observe the on/off state changes in UISwitch")
    }
    
    func testObserveOnStateInSwitchCurrentState() {
        
        var result = false
        
        switchControl.on = true
        
        observe(switchIsOn: switchControl)
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, true, "Should contain the current on/off state in UISwitch")
    }
    
    func testBindToOnStateInSwitch() {
        
        let onState = ObservableOf<Bool>()
        
        observe(onState)
            .bindTo(switchIsOn(switchControl))
            .addTo(signalsBag)
        
        onState.dispatch(true)
        
        XCTAssertEqual(switchControl.on, true, "Should bind a Boolean value to the on/off state of UISwitch")
    }
}
