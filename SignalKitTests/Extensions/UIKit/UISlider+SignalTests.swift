//
//  UISlider+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UISlider_SignalTests: XCTestCase {
    
    var slider: MockSlider!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        signalsBag = DisposableBag()
        slider = MockSlider()
        slider.maximumValue = 20
    }
    
    func testObserveValueChanges() {
        
        var result: Float = 0
        
        slider.observe().valueChanges
            .next { result = $0 }
            .addTo(signalsBag)
        
        slider.value = 10
        slider.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, 10, "Should observe for value changes in UISlider")
    }
    
    func testObserveCurrentValue() {
        
        var result: Float = 0
        
        slider.value = 10
        
        slider.observe().valueChanges
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, 10, "Should dispatch the current value from UISlider")
    }
    
    func testBindToValue() {
        
        let signal = MockSignal<Float>()
        
        signal.dispatch(5)
        
        signal.bindTo(valueIn: slider).addTo(signalsBag)
        
        XCTAssertEqual(slider.value, 5, "Should bind a Float value to the value property of UISlider")
    }
}
