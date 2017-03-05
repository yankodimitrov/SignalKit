//
//  UIDatePickerExtensionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 3/6/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class UIDatePickerExtensionsTests: XCTestCase {

    var bag: DisposableBag!
    
    override func setUp() {
        super.setUp()
        
        bag = DisposableBag()
    }
    
    func testObserveDateChanges() {
        
        let picker = MockDatePicker()
        var result = Date()
        let newDate = Date(timeIntervalSince1970: 0)
        
        picker.observe().date
            .next { result = $0 }
            .disposeWith(bag)
        
        picker.date = newDate
        picker.sendActions(for: .valueChanged)
        
        XCTAssertEqual(result, newDate, "Should observe the value changes in UIDatePicker")
    }
}
