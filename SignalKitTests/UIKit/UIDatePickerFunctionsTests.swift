//
//  UIDatePickerFunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class UIDatePickerFunctionsTests: XCTestCase {

    var datePicker: MockDatePicker!
    var signalsBag: SignalBag!
    
    override func setUp() {
        super.setUp()
        
        datePicker = MockDatePicker()
        signalsBag = SignalBag()
    }
    
    func testObserveDateInDatePicker() {
        
        var result = NSDate()
        let newDate = NSDate(timeIntervalSinceNow: 10)
        
        observe(dateIn: datePicker)
            .next { result = $0 }
            .addTo(signalsBag)
        
        datePicker.date = newDate
        datePicker.sendActionsForControlEvents(.ValueChanged)
        
        XCTAssertEqual(result, newDate, "Should observe UIDatePicker for date changes")
    }
    
    func testObserveDateInDatePickerCurrentState() {
        
        var result = NSDate()
        let newDate = NSDate(timeIntervalSinceNow: 10)
        
        datePicker.date = newDate
        
        observe(dateIn: datePicker)
            .next { result = $0 }
            .addTo(signalsBag)
        
        XCTAssertEqual(result, newDate, "Should contain the current date from UIDatePicker")
    }
}
