//
//  UIBarItem+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
import UIKit
@testable import SignalKit

class UIBarItem_SignalTests: XCTestCase {

    var barItem: UIBarItem!
    var signalsBag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        barItem = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: "")
        signalsBag = DisposableBag()
    }
    
    func testBindToEnabled() {
        
        let signal = MockSignal<Bool>()
        
        barItem.enabled = true
        
        signal.bindTo(enabled: barItem).disposeWith(signalsBag)
        
        signal.dispatch(false)
        
        XCTAssertEqual(barItem.enabled, false, "Should bind a boolean signal to the enabled property of UIBarItem")
    }
}
