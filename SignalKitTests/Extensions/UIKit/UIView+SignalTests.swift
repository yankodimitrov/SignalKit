//
//  UIView+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class UIView_SignalTests: XCTestCase {
    
    var view: UIView!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        view = UIView()
        signalsBag = SignalBag()
    }
    
    func testBindToBackgroundColor() {
        
        let color = UIColor.greenColor()
        let signal = MockSignal<UIColor>()
        
        signal.dispatch(color)
        
        signal.bindTo(backgroundColorIn: view).addTo(signalsBag)
        
        XCTAssertEqual(view.backgroundColor!, color, "Should bind a UIColor to the background color property of UIView")
    }
    
    func testBindToAlpha() {
        
        let signal = MockSignal<CGFloat>()
        
        view.alpha = 1
        
        signal.dispatch(0.5)
        
        signal.bindTo(alphaIn: view).addTo(signalsBag)
        
        XCTAssertEqual(view.alpha, 0.5, "Should bind a CGFloat value to the alpha property of UIView")
    }
    
    func testBindToHiddenState() {
        
        let signal = MockSignal<Bool>()
        
        view.hidden = false
        
        signal.dispatch(true)
        
        signal.bindTo(hiddenStateIn: view).addTo(signalsBag)
        
        XCTAssertEqual(view.hidden, true, "Should bind a Boolean value to the hidden property of UIView")
    }
}
