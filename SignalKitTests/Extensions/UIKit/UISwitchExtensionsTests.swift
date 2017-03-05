//
//  UISwitchExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UISwitchExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveStateChanges() {
        
        var result = false
        let switchControl = MockSwitch()
        
        switchControl.isOn = false
        
        switchControl.observe().onState
            .next { result = $0 }
            .disposeWith(bag)
        
        switchControl.isOn = true
        switchControl.sendActions(for: .valueChanged)
        
        XCTAssertTrue(result, "Should observe the UISwitch for state changes")
    }
}
