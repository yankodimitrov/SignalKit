//
//  ObserverOfTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class ObserverOfTests: XCTestCase {

    var userName: ObservableOf<String>!
    
    override func setUp() {
        super.setUp()
        
        userName = ObservableOf<String>()
    }
    
    func testObserve() {
        
        let observer = ObserverOf<ObservableOf<String>>(observe: userName) {
            _ in
        }
        
        XCTAssertEqual(userName.observersCount, 1, "Should observe the observable")
    }
    
    func testObserveCallback() {
        
        var result = ""
        
        let observer = ObserverOf<ObservableOf<String>>(observe: userName) {
            result = $0
        }
        
        userName.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should call the callback with the newly dispatched value from the observable")
    }
    
    func testDispose() {
        
        let observer = ObserverOf<ObservableOf<String>>(observe: userName) {
            _ in
        }
        
        observer.dispose()
        
        XCTAssertEqual(userName.observersCount, 0, "Should remove the observer upon disposal")
    }
}
