//
//  UISegmentedControlExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UISegmentedControlExtensionsTests: XCTestCase {
 
    var bag: DisposableBag!
    var segmentedControl: MockSegmentedControl!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
        segmentedControl = MockSegmentedControl()
        segmentedControl.insertSegmentWithTitle("", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("", atIndex: 1, animated: false)
    }
    
    func testObserveSelectedIndex() {
        
        var result = 0
        
        segmentedControl.observe().selectedIndex
            .next { result = $0 }
            .disposeWith(bag)
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, 1, "Should observe the selected index changes in UISegmentedControl")
    }
}
