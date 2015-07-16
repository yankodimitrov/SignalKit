//
//  UISegmentedControlFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/16/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UISegmentedControlFunctionsTests: XCTestCase {

    var signalContainer: SignalContainer!
    var segmentedControl: MockSegmentedControl!
    
    override func setUp() {
        super.setUp()
        
        signalContainer = SignalContainer()
        segmentedControl = MockSegmentedControl()
        
        segmentedControl.insertSegmentWithTitle("1", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("2", atIndex: 1, animated: false)
    }
    
    func testObserveSelectedIndexIn() {
        
        var result = 0
        
        observe(selectedIndexIn: segmentedControl)
            .next { result = $0 }
            .addTo(signalContainer)
        
        segmentedControl.selectedSegmentIndex = 1
        
        segmentedControl.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, 1, "Should observe a UISegmentedControl for selected index changes")
    }
}
