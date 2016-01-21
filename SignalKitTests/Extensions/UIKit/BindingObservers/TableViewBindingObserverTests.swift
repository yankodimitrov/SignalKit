//
//  TableViewBindingObserverTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 1/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import XCTest
@testable import SignalKit

class TableViewBindingObserverTests: XCTestCase {

    func testDisposeBindingObserver() {
        
        let fakeDisposable = MockDisposable()
        let binding = TableViewBindingObserver()
        
        binding.observer = fakeDisposable
        
        binding.dispose()
        
        XCTAssertEqual(fakeDisposable.isDisposeCalled, true, "Should dispose the binding")
        XCTAssert(binding.observer == nil, "Should set the disposable observer to nil")
    }
}
