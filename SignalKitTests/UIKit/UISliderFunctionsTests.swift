//
//  UISliderFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UISliderFunctionsTests: XCTestCase {

    var slider: MockSlider!
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        slider = MockSlider()
        slider.maximumValue = 20
        signalContainer = SignalContainer()
    }
    
    func testObserveValueIn() {
        
        var result: Float = 0
        
        observe(valueIn: slider)
            .next { result = $0 }
            .addTo(signalContainer)
        
        slider.value = 10
        slider.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, 10, "Should observe UISlider for value changes")
    }
    
    func testObserveCurrentValueInSlider() {
        
        var result: Float = 0
        
        slider.value = 10
        
        observe(valueIn: slider)
            .next { result = $0 }
            .addTo(signalContainer)
        
        XCTAssertEqual(result, 10, "Should contain the current value in UISlider")
    }
    
    func testBindToValueIn() {
        
        let value = ObservableOf<Float>()
        
        observe(value)
            .bindTo(valueIn(slider))
            .addTo(signalContainer)
        
        value.dispatch(12)
        
        XCTAssertEqual(slider.value, 12, "Should bind a Float value to the value property of UISlider")
    }
}
