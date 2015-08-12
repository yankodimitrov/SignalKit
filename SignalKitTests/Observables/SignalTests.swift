//
//  SignalTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 8/12/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import XCTest

class SignalTests: XCTestCase {
    
    var userName: ObservableProperty<String>!
    
    override func setUp() {
        super.setUp()
        
        userName = ObservableProperty<String>(value: "", lock: MockLock())
    }
    
    func testObserveObservable() {
        
        let signal = Signal<String>()
        var result = ""
        
        signal.addObserver { result = $0 }
        signal.observe(userName)
        
        userName.value = "John"
        
        XCTAssertEqual(result, "John", "Should observe an observable of the same type")
    }
    
    func testDispose() {
        
        let signal = Signal<String>()
        var result = ""
        
        signal.addObserver { result = $0 }
        signal.observe(userName)
        signal.dispose()
        
        userName.value = "John"
        
        XCTAssertEqual(result, "", "Should dispose the observation")
    }
    
    func testDisposeThePreviousObservation() {
        
        let disposable = MockDisposable()
        let name = StubObservable<String>(disposable: disposable)
        let signal = Signal<String>()
        
        signal.addObserver { v in }
        
        signal.observe(name)
        signal.observe(name)
        
        XCTAssertEqual(disposable.isDisposeCalled, true, "Should dispose the previous observation")
    }
}
