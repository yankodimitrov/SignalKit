//
//  UISegmentedControl+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class UISegmentedControl_SignalTests: XCTestCase {
    
    var segmentedControl: MockSegmentedControl!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        signalsBag = SignalBag()
        
        segmentedControl = MockSegmentedControl()
        segmentedControl.insertSegmentWithTitle("", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("", atIndex: 1, animated: false)
    }
    
    func testObserveSelectedIndex() {
        
        var result = 0
        
        segmentedControl.observe().selectedIndex
            .next { result = $0 }
            .addTo(signalsBag)
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, 1, "Should observe the UISegmentedControl for selected index changes")
    }
}
