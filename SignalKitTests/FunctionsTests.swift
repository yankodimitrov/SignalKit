//
//  FunctionsTests.swift
//  SignalKit
//
//  Created by Yanko Dimitrov on 7/15/15.
//  Copyright (c) 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import XCTest

class FunctionsTests: XCTestCase {

    var person: Person!
    
    override func setUp() {
        super.setUp()
        
        person = Person(name: "")
    }
    
    /// MARK: - Observe Observable
    
    func testObserveObservable() {
        
        let name = ObservableOf<String>()
        var result = ""
        
        let signal = observe(name) {
            result = $0
        }
        
        name.dispatch("John")
        
        XCTAssertEqual(result, "John", "Should observe an observable")
    }
    
    func testObserveObservableWithoutCallback() {
        
        let name = ObservableOf<String>()
        
        let signal = observe(name)
        
        XCTAssertEqual(name.observersCount, 1, "Should observe an observable even without a callback")
    }
    
    func testObserveObservableWillDispose() {
        
        let name = ObservableOf<String>()
        var result = ""
        
        let signal = observe(name) {
            result = $0
        }
        
        signal.dispose()
        
        name.dispatch("John")
        
        XCTAssertEqual(result, "", "Should dispose the observation")
    }
    
    /// MARK: - Observe key path
    
    func testObserveKeyPath() {
        
        var name = ""
        
        let signal = observe(keyPath: "name", value: "", object: person) {
            
            name = $0
        }
        
        person.name = "Jack"
        
        XCTAssertEqual(name, "Jack", "Should observe a NSObject for the given key path")
    }
    
    func testObserveKeyPathCallbackCalled() {
        
        var name = ""
        
        let signal = observe(keyPath: "name", value: "", object: person) {
            
            name = $0
        }
        
        person.name = "Jack"
        
        XCTAssertEqual(name, "Jack", "Should call the observe key path callback")
    }
    
    func testObserveKeyPathDispose() {
        
        
        var name = ""
        
        let signal = observe(keyPath: "name", value: "", object: person) {
            
            name = $0
        }
        
        signal.dispose()
        
        person.name = "Jack"
        
        XCTAssertEqual(name, "", "Should dispose the observation")
    }
}
