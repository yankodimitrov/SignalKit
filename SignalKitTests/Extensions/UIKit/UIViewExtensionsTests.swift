//
//  UIViewExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIViewExtensionsTests: XCTestCase {
    
    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testBindToAlpha() {
        
        let signal = Signal<CGFloat>()
        let view = UIView()
        
        view.alpha = 1
        
        signal.bindTo(alphaIn: view).disposeWith(bag)
        
        signal.send(0.5)
        
        XCTAssertEqual(view.alpha, 0.5, "Should bind the CGFloat value to the alpha property of UIView")
    }
    
    func testBindToHiddenState() {
        
        let signal = Signal<Bool>()
        let view = UIView()
        
        view.isHidden = false
        
        signal.bindTo(hiddenStateIn: view).disposeWith(bag)
        
        signal.send(true)
        
        XCTAssertTrue(view.isHidden, "Should bind boolean value to the hidden property of UIView")
    }
}
