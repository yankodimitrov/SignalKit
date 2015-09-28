//
//  UIDatePicker+SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/16/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIDatePicker_SignalTests: XCTestCase {

    var picker: MockDatePicker!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        picker = MockDatePicker()
        signalsBag = SignalBag()
    }
    
    func testObserveDateChangeEvents() {
        
        var result = NSDate()
        let newDate = NSDate(timeIntervalSinceNow: 0)
        
        picker.observe().date
            .next { result = $0 }
            .addTo(signalsBag)
        
        picker.date = newDate
        picker.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, newDate, "Should observe the UIDatePicker for date changes")
    }
    
    func testObserveDateChangeCurrentDate() {
        
        var result = NSDate()
        let newDate = NSDate(timeIntervalSinceNow: 0)
        
        picker.date = newDate
        
        picker.observe().date
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, newDate, "Should dispatch the current date from UIDatePicker")
    }
}
