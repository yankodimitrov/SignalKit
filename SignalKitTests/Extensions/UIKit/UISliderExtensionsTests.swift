//
//  UISliderExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UISliderExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveValueChanges() {
        
        var result: Float = 0
        let slider = MockSlider()
        slider.maximumValue = 20
        
        slider.observe().valueChanges
            .next { result = $0 }
            .disposeWith(bag)
        
        slider.value = 10
        slider.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, 10, "Should observe the UISlider for value changes")
    }
}
