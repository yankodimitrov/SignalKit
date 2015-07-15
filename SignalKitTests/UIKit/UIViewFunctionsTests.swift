//
//  UIViewFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UIViewFunctionsTests: XCTestCase {

    var view: UIView!
    var signalContainer: SignalContainer!
    
    override func setUp() {
        super.setUp()
        
        view = UIView()
        signalContainer = SignalContainer()
    }
    
    func testBindToBackgroundColor() {
        
        let color = UIColor.whiteColor()
        let observable = ObservableOf<UIColor>()
        
        observe(observable)
            .bindTo(backgroundColorIn(view))
            .addTo(signalContainer)
        
        observable.dispatch(color)
        
        XCTAssertEqual(view.backgroundColor!, color, "Should bind a UIColor to the background color of UIView")
    }
    
    func testBindToAlpha() {
        
        let alpha = ObservableOf<CGFloat>()
        
        view.alpha = 1
        
        observe(alpha)
            .bindTo(alphaIn(view))
            .addTo(signalContainer)
        
        alpha.dispatch(0.5)
        
        XCTAssertEqual(view.alpha, 0.5, "Should bind a CGFloat value to the alpha value in UIView")
    }
    
    func testBindToViewIsHidden() {
        
        let hiddenState = ObservableOf<Bool>()
        
        observe(hiddenState)
            .bindTo(viewIsHidden(view))
            .addTo(signalContainer)
        
        hiddenState.dispatch(true)
        
        XCTAssertEqual(view.hidden, true, "Should bind a Boolean value to the hidden property of UIView")
    }
}
